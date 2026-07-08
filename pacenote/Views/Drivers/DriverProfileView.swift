import SwiftUI

struct DriverProfileView: View {
    let driverId: String
    @State private var profile: DriverProfileData?
    @State private var seasonResults: [DriverEventResult] = []
    @State private var highlights: [CareerHighlight] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView().padding(80).tint(MagazineColors.accent)
            } else if let profile {
                VStack(spacing: 28) {
                    heroSection(profile)
                    careerStatsSection(profile)
                    seasonResultsSection()
                    highlightsSection()
                }
                .padding(20)
            }
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadData() }
    }

    private func loadData() async {
        let mock = MockDataService.shared
        profile = await mock.driverProfile(driverId)
        let year = Calendar.current.component(.year, from: Date())
        seasonResults = await mock.driverSeasonResults(driverId, season: year)
        highlights = await mock.driverCareerHighlights(driverId)
        isLoading = false
    }

    private func heroSection(_ p: DriverProfileData) -> some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 48)
                    .fill(MagazineColors.surfaceAlt)
                    .frame(width: 80, height: 80)
                Text("\(p.carNumber)")
                    .font(MagazineFont.monoBold(28))
                    .foregroundColor(MagazineColors.accent)
            }

            VStack(spacing: 6) {
                Text("\(p.firstName) \(p.lastName)")
                    .font(MagazineFont.serifBold(24))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("\(p.nationality) · \(p.team)")
                    .font(MagazineFont.body)
                    .foregroundColor(MagazineColors.textSecondary)
                Text("\(p.carName) | 领航: \(p.codriver)")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textTertiary)
            }

            HStack(spacing: 0) {
                StatCell(value: "\(p.careerStarts)", label: L10n.Driver.starts)
                Rectangle().fill(MagazineColors.divider).frame(width: 0.5, height: 36)
                StatCell(value: "\(p.championshipTitles)", label: L10n.Driver.titles)
                Rectangle().fill(MagazineColors.divider).frame(width: 0.5, height: 36)
                StatCell(value: "\(p.careerWins)", label: L10n.Driver.wins)
                Rectangle().fill(MagazineColors.divider).frame(width: 0.5, height: 36)
                StatCell(value: "\(p.careerPodiums)", label: L10n.Driver.podiums)
            }
            .magazineCard()

            Text(p.bio)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(MagazineColors.textSecondary)
                .lineSpacing(6)
        }
    }

    private func careerStatsSection(_ p: DriverProfileData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            MagazineSectionTitle(L10n.Driver.career)

            VStack(alignment: .leading, spacing: 12) {
                statBar(label: L10n.Driver.winRate, value: p.careerStarts > 0 ? Double(p.careerWins) / Double(p.careerStarts) : 0, color: MagazineColors.accent)
                statBar(label: L10n.Driver.podiumRate, value: p.careerStarts > 0 ? Double(p.careerPodiums) / Double(p.careerStarts) : 0, color: Color(hex: "#FBBF24"))
            }
            .padding(20)
            .magazineCard()
        }
    }

    private func seasonResultsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            MagazineSectionTitle(L10n.Driver.currentSeason)

            if seasonResults.isEmpty {
                Text(L10n.Loading.driverData)
                    .font(MagazineFont.serifRegular(15))
                    .foregroundColor(MagazineColors.textSecondary)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 0) {
                    ForEach(seasonResults) { result in
                        SeasonEventRow(result: result)
                    }
                }
                .magazineCard()
            }
        }
    }

    private func highlightsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !highlights.isEmpty {
                MagazineSectionTitle(L10n.Driver.highlights)

                VStack(spacing: 0) {
                    ForEach(Array(highlights.enumerated()), id: \.element.id) { i, h in
                        HStack(alignment: .top, spacing: 14) {
                            Text(String(h.year))
                                .font(MagazineFont.monoBold(14))
                                .foregroundColor(MagazineColors.accent)
                                .frame(width: 40, alignment: .leading)

                            Rectangle()
                                .fill(MagazineColors.divider)
                                .frame(width: 0.5)
                                .frame(maxHeight: .infinity)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(h.title)
                                    .font(MagazineFont.body.weight(.medium))
                                    .foregroundColor(MagazineColors.textPrimary)
                                Text(h.description)
                                    .font(MagazineFont.caption)
                                    .foregroundColor(MagazineColors.textSecondary)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.bottom, i < highlights.count - 1 ? 20 : 0)
                    }
                }
                .padding(20)
                .magazineCard()
            }
        }
    }

    private func statBar(label: String, value: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(MagazineFont.monoMedium(11))
                    .foregroundColor(MagazineColors.textSecondary)
                Spacer()
                Text(String(format: "%.0f%%", value * 100))
                    .font(MagazineFont.monoBold(13))
                    .foregroundColor(color)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle().fill(MagazineColors.divider).frame(height: 4)
                    Rectangle().fill(color).frame(width: geo.size.width * value, height: 4)
                }
            }
            .frame(height: 4)
        }
    }
}

struct SeasonEventRow: View {
    let result: DriverEventResult

    var body: some View {
        HStack(spacing: 12) {
            Text(result.eventName)
                .font(MagazineFont.body.weight(.medium))
                .foregroundColor(MagazineColors.textPrimary)

            Spacer()

            HStack(spacing: 8) {
                Text("P\(result.position)")
                    .font(MagazineFont.monoBold(12))
                    .foregroundColor(result.position <= 3 ? MagazineColors.accent : MagazineColors.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(result.position <= 3 ? MagazineColors.accent.opacity(0.12) : MagazineColors.divider)

                Text(String(format: "%.0f", result.points))
                    .font(MagazineFont.monoBold(14))
                    .foregroundColor(MagazineColors.accent)
                    .frame(width: 32, alignment: .trailing)
            }
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }
}

struct StatCell: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(MagazineFont.monoBold(18))
                .foregroundColor(MagazineColors.accent)
            Text(label)
                .font(MagazineFont.caption)
                .foregroundColor(MagazineColors.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
