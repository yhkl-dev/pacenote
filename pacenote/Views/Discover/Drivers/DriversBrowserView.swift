import SwiftUI

@MainActor
@Observable
final class DriversBrowserViewModel {
    var drivers: [DriverSummary] = []
    var isLoading = true
    var errorMessage: String?

    func load() async {
        isLoading = true
        do {
            let seasonsRaw = try await APIClient.shared.fetchRaw("/api/seasons")
            let seasons = try JSONDecoder().decode(SportradarSeasonsResponse.self, from: seasonsRaw)
            let wrcId = seasons.stages.first(where: { $0.description.contains("World Rally Championship") })?.id ?? "sr:stage:1315611"
            let raw = try await APIClient.shared.fetchRaw("/api/seasons/\(wrcId)/events")
            let schedule = try JSONDecoder().decode(ScheduleResponse.self, from: raw)
            guard let firstEvent = schedule.stages.first else { throw APIError.invalidResponse }
            let eventRaw = try await APIClient.shared.fetchRaw("/api/event/\(firstEvent.id)/summary")
            let data = try JSONDecoder().decode(RawSummaryJSON.self, from: eventRaw)
            drivers = data.extractDrivers()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct DriverSummary: Identifiable {
    let id: String
    let name: String
    let carNumber: Int
    let position: Int?
    let status: String?
}

struct RawSummaryJSON: Decodable {
    let stage: RawStageData

    struct RawStageData: Decodable {
        let competitors: [RawComp]
    }

    struct RawComp: Decodable {
        let id: String
        let name: String
        let carNumber: Int?
        let result: RawResult?

        enum CodingKeys: String, CodingKey {
            case id, name, result
            case carNumber = "car_number"
        }
    }

    struct RawResult: Decodable {
        let position: Int?
        let status: String?
    }

    func extractDrivers() -> [DriverSummary] {
        stage.competitors.map { comp in
            DriverSummary(
                id: comp.id,
                name: comp.name,
                carNumber: comp.carNumber ?? 0,
                position: comp.result?.position,
                status: comp.result?.status
            )
        }
    }
}

struct DriversBrowserView: View {
    @State private var vm = DriversBrowserViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("车手与车队")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                if vm.isLoading {
                    ProgressView().padding(40).tint(MagazineColors.accent)
                } else if let error = vm.errorMessage {
                    Text(error).font(MagazineFont.caption).foregroundColor(MagazineColors.textSecondary)
                } else {
                    VStack(spacing: 0) {
                        ForEach(vm.drivers.prefix(30)) { driver in
                            NavigationLink(destination: DriverProfileView(driverId: driver.id)) {
                                DriverBrowserRow(driver: driver)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }
}

struct DriverBrowserRow: View {
    let driver: DriverSummary

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(MagazineColors.surfaceAlt)
                    .frame(width: 40, height: 40)
                Text(String(driver.name.prefix(2)).uppercased())
                    .font(MagazineFont.monoBold(12))
                    .foregroundColor(MagazineColors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(driver.name)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("#\(driver.carNumber) · \(driver.status ?? "—")")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Spacer()

            if let pos = driver.position {
                Text("P\(pos)")
                    .font(MagazineFont.monoBold(14))
                    .foregroundColor(pos <= 3 ? MagazineColors.accent : MagazineColors.textSecondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MagazineColors.textTertiary)
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }
}
