import SwiftUI

struct StageDetailView: View {
    let eventId: String
    let stage: Stage

    @State private var viewModel = EventViewModel()
    @AppStorage("spoilerFreeMode") private var spoilerFreeMode = true
    @State private var revealed = false

    var body: some View {
        Group {
            if spoilerFreeMode && !revealed && stage.status == .completed {
                SpoilerOverlay(stageName: stage.name) { withAnimation { revealed = true } }
            } else {
                resultsContent
            }
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadStageResults(eventId: eventId, stageId: stage.stageId)
            await viewModel.loadStageMeta(stageId: stage.stageId)
        }
    }

    private var resultsContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                stageHero

                if let meta = viewModel.selectedStageMeta {
                    stageMetaCard(meta)
                }

                if viewModel.isLoading && viewModel.selectedStageResults.isEmpty {
                    ProgressView().padding(60).frame(maxWidth: .infinity).tint(MagazineColors.accent)
                } else if viewModel.selectedStageResults.isEmpty {
                    VStack(spacing: 16) {
                        Text(stage.status == .upcoming ? L10n.Stage.notStarted : L10n.Stage.noResults)
                            .font(MagazineFont.serifRegular(15))
                            .foregroundColor(MagazineColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity).padding(.top, 40)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(viewModel.selectedStageResults.enumerated()), id: \.offset) { i, r in
                            ResultRow(position: i + 1, result: r)
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: viewModel.selectedStageResults.count)
                }
            }
            .padding(20)
        }
    }

    private var stageHero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SS\(stage.stageNumber)")
                        .font(MagazineFont.monoBold(28))
                        .foregroundColor(MagazineColors.accent)
                    Text(stage.name)
                        .font(MagazineFont.serifBold(22))
                        .foregroundColor(MagazineColors.textPrimary)
                }
                Spacer()
                StatusDot(status: stage.status)
            }

            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(String(format: "%.2f km", stage.distance))
                        .font(MagazineFont.monoBold(22))
                        .foregroundColor(MagazineColors.textPrimary)
                    Text(L10n.Stage.distance)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(stage.surfaceCN.isEmpty ? stage.surface : stage.surfaceCN)
                        .font(MagazineFont.body.weight(.medium))
                        .foregroundColor(MagazineColors.textPrimary)
                    Text(L10n.Stage.surface)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                }
            }
        }
        .magazineCard()
    }

    private func stageMetaCard(_ meta: StageMetadata) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            stageMapPlaceholder(meta)

            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Stage.weather)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                    HStack(spacing: 6) {
                        Image(systemName: meta.weatherIcon)
                            .foregroundColor(weatherColor(meta.weather))
                        Text(weatherLabel(meta.weather))
                            .font(MagazineFont.body.weight(.medium))
                            .foregroundColor(MagazineColors.textPrimary)
                    }
                    Text("\(meta.temperature)°C")
                        .font(MagazineFont.monoMedium(13))
                        .foregroundColor(MagazineColors.textSecondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.Stage.elevation)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up")
                            .font(.caption)
                            .foregroundColor(MagazineColors.live)
                        Text("+\(meta.elevationGain)m")
                            .font(MagazineFont.monoMedium(13))
                            .foregroundColor(MagazineColors.live)
                        Image(systemName: "arrow.down")
                            .font(.caption)
                            .foregroundColor(MagazineColors.completed)
                            .padding(.leading, 4)
                        Text("-\(meta.elevationLoss)m")
                            .font(MagazineFont.monoMedium(13))
                            .foregroundColor(MagazineColors.completed)
                    }
                    Text("\(meta.startAltitude)m → \(meta.finishAltitude)m")
                        .font(MagazineFont.timingSmall)
                        .foregroundColor(MagazineColors.textTertiary)
                }
            }

            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)

            VStack(alignment: .leading, spacing: 4) {
                Text(L10n.Stage.historicalBest)
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textTertiary)
                HStack(spacing: 10) {
                    Text(meta.historicalFastest)
                        .font(MagazineFont.monoBold(18))
                        .foregroundColor(MagazineColors.accent)
                    Text(meta.historicalDriver)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textSecondary)
                }
            }
        }
        .padding(20)
        .magazineCard()
    }

    private func stageMapPlaceholder(_ meta: StageMetadata) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(MagazineColors.surfaceAlt)
                .frame(height: 120)

            VStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.title2)
                    .foregroundColor(MagazineColors.textTertiary)

                HStack(spacing: 16) {
                    Label("\(meta.startAltitude)m", systemImage: "flag")
                        .font(MagazineFont.monoMedium(11))
                        .foregroundColor(MagazineColors.textTertiary)
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                    Label("\(meta.finishAltitude)m", systemImage: "flag.checkered")
                        .font(MagazineFont.monoMedium(11))
                        .foregroundColor(MagazineColors.textTertiary)
                }
            }
        }
    }

    private func weatherLabel(_ weather: String) -> String {
        switch weather {
        case "sunny": return L10n.Stage.sunny
        case "cloudy": return L10n.Stage.cloudy
        case "rain": return L10n.Stage.rain
        case "snow": return L10n.Stage.snow
        default: return L10n.Stage.cloudy
        }
    }

    private func weatherColor(_ weather: String) -> Color {
        switch weather {
        case "sunny": return Color(hex: "#FBBF24")
        case "cloudy": return Color(hex: "#9CA3AF")
        case "rain": return Color(hex: "#60A5FA")
        case "snow": return Color(hex: "#E0F2FE")
        default: return Color(hex: "#9CA3AF")
        }
    }
}

struct ResultRow: View {
    let position: Int
    let result: StageResult

    var body: some View {
        HStack(spacing: 14) {
            Text("\(position)")
                .font(MagazineFont.position)
                .foregroundColor(position <= 3 ? MagazineColors.accent : MagazineColors.textTertiary)
                .frame(width: 24, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(result.driverName)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                HStack(spacing: 6) {
                    Text("#\(result.carNumber)")
                        .font(MagazineFont.timingSmall)
                        .foregroundColor(MagazineColors.textTertiary)
                    Text(result.group)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(result.stageTime)
                    .font(MagazineFont.timing)
                    .foregroundColor(MagazineColors.textPrimary)
                Text(result.diffFirst == "—" ? "—" : "+\(result.diffFirst.replacingOccurrences(of: "+", with: ""))")
                    .font(MagazineFont.timingSmall)
                    .foregroundColor(MagazineColors.live)
            }
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
        .background(position <= 3 ? MagazineColors.accentMuted : Color.clear)
    }
}
