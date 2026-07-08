import SwiftUI

struct DiscoverView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("Discover")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)
                    .padding(.horizontal, 20)

                VStack(spacing: 16) {
                    NavigationLink(destination: EncyclopediaView()) {
                        DiscoverCard(
                            icon: "arrow.triangle.turn.up.right.diamond",
                            title: "拉力百科",
                            subtitle: "路书系统 · 组别规则 · 赛车技术 · 计分方式",
                            accent: MagazineColors.accent
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: DriversBrowserView()) {
                        DiscoverCard(
                            icon: "person.3",
                            title: "车手与车队",
                            subtitle: "WRC 现役车手资料 · 车队历史",
                            accent: Color(hex: "#60A5FA")
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: HistoryView()) {
                        DiscoverCard(
                            icon: "clock.arrow.circlepath",
                            title: "拉力历史",
                            subtitle: "Group B · 传奇车手 · 经典赛季",
                            accent: Color(hex: "#F59E0B")
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink(destination: GameTracksView()) {
                        DiscoverCard(
                            icon: "gamecontroller",
                            title: "游戏赛道",
                            subtitle: "EA WRC · DiRT Rally 2.0 · WRC Generations · RBR",
                            accent: Color(hex: "#A78BFA")
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 8)
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DiscoverCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let accent: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(accent.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(accent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(MagazineFont.serifSemibold(17))
                    .foregroundColor(MagazineColors.textPrimary)
                Text(subtitle)
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MagazineColors.textTertiary)
        }
        .padding(20)
        .magazineCard()
    }
}
