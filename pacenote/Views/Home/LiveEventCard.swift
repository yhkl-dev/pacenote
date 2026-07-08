import SwiftUI

struct LiveEventCard: View {
    let event: RallyEvent
    let spoilerFree: Bool

    @State private var revealed = false

    var body: some View {
        VStack(spacing: 0) {
            if spoilerFree && !revealed {
                spoilerOverlay
            } else {
                liveContent
            }
        }
        .magazineCard()
        .overlay(alignment: .topLeading) {
            Rectangle()
                .fill(MagazineColors.live)
                .frame(width: 3, height: 28)
                .offset(x: -1, y: 16)
        }
        .animation(.easeInOut(duration: 0.35), value: revealed)
    }

    private var spoilerOverlay: some View {
        VStack(spacing: 24) {
            Text("!!")
                .font(MagazineFont.monoBold(28))
                .foregroundColor(MagazineColors.accent)

            VStack(spacing: 6) {
                Text(L10n.Spoiler.enabled)
                    .font(MagazineFont.serifSemibold(17))
                    .foregroundColor(MagazineColors.textPrimary)
                Text(L10n.Spoiler.eventLive(event.displayName))
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Button {
                withAnimation(.easeInOut(duration: 0.3)) { revealed = true }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "eye")
                    Text(L10n.Spoiler.reveal)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(MagazineColors.background)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(MagazineColors.accent)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }

    private var liveContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(MagazineColors.live).frame(width: 6, height: 6)
                    Text("LIVE")
                        .font(MagazineFont.monoBold(10))
                        .foregroundColor(MagazineColors.live)
                        .tracking(2)
                }
                Spacer()
                Text(String(format: L10n.Event.round, event.roundNumber))
                    .font(MagazineFont.monoMedium(10))
                    .foregroundColor(MagazineColors.textTertiary)
            }

            Text(event.displayName)
                .font(MagazineFont.serifBold(22))
                .foregroundColor(MagazineColors.textPrimary)
            Text(event.countryCN.isEmpty ? event.country : event.countryCN)
                .font(MagazineFont.body)
                .foregroundColor(MagazineColors.textSecondary)

            HStack(spacing: 6) {
                Text(L10n.Event.leaderHint)
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textTertiary)
                Image(systemName: "arrow.right")
                    .font(.caption2)
                    .foregroundColor(MagazineColors.textTertiary)
            }
        }
    }
}
