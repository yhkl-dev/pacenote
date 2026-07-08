import SwiftUI

@MainActor
@Observable
final class DriverProfileViewModel {
    var profile: SRCompetitorProfile?
    var isLoading = true
    var errorMessage: String?

    func load(driverId: String) async {
        isLoading = true
        do {
            let raw = try await APIClient.shared.fetchRaw("/api/driver/\(driverId)")
            let decoded = try JSONDecoder().decode(SRProfileResponse.self, from: raw)
            profile = decoded.competitor
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct SRProfileResponse: Decodable {
    let competitor: SRCompetitorProfile
}

struct SRCompetitorProfile: Decodable {
    let id: String
    let name: String
    let nationality: String
    let countryCode: String?
    let abbreviation: String?
    let gender: String?

    enum CodingKeys: String, CodingKey {
        case id, name, nationality, gender, abbreviation
        case countryCode = "country_code"
    }
}

struct DriverProfileView: View {
    let driverId: String
    @State private var vm = DriverProfileViewModel()

    var body: some View {
        ScrollView {
            if vm.isLoading {
                ProgressView().padding(80).tint(MagazineColors.accent)
            } else if let error = vm.errorMessage {
                VStack(spacing: 16) {
                    Text(error).font(MagazineFont.caption).foregroundColor(MagazineColors.textSecondary)
                }.padding(60)
            } else if let profile = vm.profile {
                VStack(spacing: 28) {
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 48)
                                .fill(MagazineColors.surfaceAlt)
                                .frame(width: 80, height: 80)
                            Text(profile.abbreviation ?? String(profile.name.prefix(3)).uppercased())
                                .font(MagazineFont.monoBold(22))
                                .foregroundColor(MagazineColors.accent)
                        }
                        VStack(spacing: 6) {
                            Text(profile.name)
                                .font(MagazineFont.serifBold(24))
                                .foregroundColor(MagazineColors.textPrimary)
                            HStack(spacing: 8) {
                                Text(profile.nationality)
                                    .font(MagazineFont.body)
                                    .foregroundColor(MagazineColors.textSecondary)
                                if let code = profile.countryCode {
                                    Text(code)
                                        .font(MagazineFont.monoMedium(11))
                                        .foregroundColor(MagazineColors.textTertiary)
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(Rectangle().strokeBorder(MagazineColors.divider, lineWidth: 0.5))
                                }
                            }
                        }
                        HStack(spacing: 0) {
                            StatCell(value: profile.gender == "male" ? "♂" : "♀", label: "性别")
                            Rectangle().fill(MagazineColors.divider).frame(width: 0.5, height: 36)
                            StatCell(value: profile.abbreviation ?? "—", label: "缩写")
                            Rectangle().fill(MagazineColors.divider).frame(width: 0.5, height: 36)
                            StatCell(value: profile.id.components(separatedBy: ":").last ?? "—", label: "ID")
                        }
                        .magazineCard()
                    }
                }
                .padding(20)
            }
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load(driverId: driverId) }
    }
}

struct StatCell: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(MagazineFont.monoBold(18)).foregroundColor(MagazineColors.accent)
            Text(label).font(MagazineFont.caption).foregroundColor(MagazineColors.textTertiary)
        }.frame(maxWidth: .infinity)
    }
}
