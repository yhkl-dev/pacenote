import SwiftUI

struct DriverProfileView: View {
    let driverId: String

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("车手资料")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 48))
                        .foregroundColor(MagazineColors.textTertiary)
                    Text("车手数据接入中")
                        .font(MagazineFont.serifRegular(16))
                        .foregroundColor(MagazineColors.textSecondary)
                    Text("Sportradar API 对接中，敬请期待")
                        .font(MagazineFont.caption)
                        .foregroundColor(MagazineColors.textTertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
                .magazineCard()
            }
            .padding(20)
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
