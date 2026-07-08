import SwiftUI

struct StandingsView: View {
    @Bindable var viewModel: StandingsViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(StandingCategory.allCases, id: \.self) { cat in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) { viewModel.selectedCategory = cat }
                    } label: {
                        Text(cat.displayName)
                            .font(MagazineFont.monoMedium(12))
                            .foregroundColor(viewModel.selectedCategory == cat ? MagazineColors.textPrimary : MagazineColors.textTertiary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .overlay(alignment: .bottom) {
                                if viewModel.selectedCategory == cat {
                                    Rectangle().fill(MagazineColors.accent).frame(height: 2)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)

            if viewModel.isLoading && viewModel.currentStandings.isEmpty {
                Spacer()
                ProgressView().tint(MagazineColors.accent)
                Spacer()
            } else if let error = viewModel.errorMessage, viewModel.currentStandings.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Text(error)
                        .font(MagazineFont.serifRegular(15))
                        .foregroundColor(MagazineColors.textSecondary)
                    Button {
                        Task { await viewModel.loadStandings() }
                    } label: {
                        Text(L10n.Error.retry)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(MagazineColors.accent)
                    }
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.currentStandings) { standing in
                            PositionRow(standing: standing)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .animation(.easeInOut(duration: 0.25), value: viewModel.currentStandings.count)
                }
            }
        }
        .background(MagazineColors.background)
        .navigationTitle(L10n.Nav.standings)
        .navigationBarTitleDisplayMode(.large)
        .refreshable { await viewModel.loadStandings() }
    }
}

struct PositionRow: View {
    let standing: Standing

    var body: some View {
        HStack(spacing: 14) {
            HStack(spacing: 6) {
                Text("\(standing.position)")
                    .font(MagazineFont.position)
                    .foregroundColor(standing.position <= 3 ? MagazineColors.accent : MagazineColors.textTertiary)
                    .frame(width: 24)

                if standing.positionChange != 0 {
                    Image(systemName: standing.positionChange > 0 ? "arrow.up" : "arrow.down")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(standing.positionChange > 0 ? MagazineColors.completed : MagazineColors.live)
                        .frame(width: 12)
                }
            }
            .frame(width: 40, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text(standing.driverName)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("\(standing.team)  \(standing.carName)")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textTertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.0f", standing.points))
                    .font(MagazineFont.points)
                    .foregroundColor(MagazineColors.accent)
                if !standing.eventPoints.isEmpty {
                    Text(standing.eventPoints)
                        .font(MagazineFont.timingSmall)
                        .foregroundColor(MagazineColors.textTertiary)
                }
            }
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
        .background(standing.position <= 3 ? MagazineColors.accentMuted : Color.clear)
    }
}
