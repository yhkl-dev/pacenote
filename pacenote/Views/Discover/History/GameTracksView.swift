import SwiftUI

struct GameTracksView: View {
    @State private var selectedGame: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("游戏赛道")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                Text("哪些拉力游戏收录了真实的 WRC 赛段？选择一款游戏查看详情。")
                    .font(MagazineFont.body)
                    .foregroundColor(MagazineColors.textSecondary)

                ForEach(GameTracksData.games) { game in
                    GameCard(game: game, isExpanded: selectedGame == game.id)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedGame = selectedGame == game.id ? nil : game.id
                            }
                        }
                }
            }
            .padding(20)
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameCard: View {
    let game: RallyGame
    let isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text(game.name)
                    .font(MagazineFont.serifSemibold(17))
                    .foregroundColor(MagazineColors.textPrimary)

                HStack(spacing: 12) {
                    Text(game.developer)
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textSecondary)
                    Text("·")
                        .foregroundColor(MagazineColors.textTertiary)
                    Text(String(game.year))
                        .font(MagazineFont.monoMedium(11))
                        .foregroundColor(MagazineColors.textTertiary)
                }

                Text(game.platforms)
                    .font(MagazineFont.monoMedium(10))
                    .foregroundColor(MagazineColors.textTertiary)

                Text(game.description)
                    .font(.system(size: 13, design: .serif))
                    .foregroundColor(MagazineColors.textSecondary)
                    .lineSpacing(4)
                    .padding(.top, 4)
            }
            .padding(20)

            if isExpanded {
                Rectangle()
                    .fill(MagazineColors.divider)
                    .frame(height: 0.5)

                VStack(spacing: 0) {
                    ForEach(Array(game.trackMatches.enumerated()), id: \.element.id) { index, match in
                        TrackMatchRow(match: match)
                        if index < game.trackMatches.count - 1 {
                            Rectangle()
                                .fill(MagazineColors.divider)
                                .frame(height: 0.5)
                                .padding(.leading, 16)
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .magazineCard()
    }
}

struct TrackMatchRow: View {
    let match: TrackMatch

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(match.stageNameInGame)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("\(match.realEventName) · \(match.country)")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Spacer()

            Text(match.surface)
                .font(MagazineFont.monoMedium(10))
                .foregroundColor(MagazineColors.textTertiary)
        }
        .padding(14)
    }
}
