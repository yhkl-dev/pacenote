import SwiftUI

struct SpoilerOverlay: View {
    let stageName: String
    let onReveal: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Text("!!")
                .font(MagazineFont.monoBold(36))
                .foregroundColor(MagazineColors.accent)

            VStack(spacing: 8) {
                Text(L10n.Spoiler.enabled)
                    .font(MagazineFont.serifSemibold(18))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("\(stageName) \(L10n.Spoiler.hidden)")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Button(action: onReveal) {
                HStack(spacing: 6) {
                    Image(systemName: "eye")
                    Text(L10n.Spoiler.reveal)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(MagazineColors.background)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(MagazineColors.accent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MagazineColors.background)
    }
}
