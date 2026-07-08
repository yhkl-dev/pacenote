import SwiftUI

struct HistoryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("拉力历史")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                VStack(spacing: 0) {
                    ForEach(Array(HistoryData.events.enumerated()), id: \.element.id) { index, event in
                        HistoryCard(event: event, isLast: index == HistoryData.events.count - 1)
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

struct HistoryCard: View {
    let event: HistoryEvent
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 4) {
                Text(String(event.year))
                    .font(MagazineFont.monoBold(18))
                    .foregroundColor(MagazineColors.accent)
                    .frame(width: 48, alignment: .leading)
            }
            .padding(.top, 2)

            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(MagazineColors.divider)
                    .frame(width: 0.5)
                    .frame(maxHeight: .infinity)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(MagazineFont.serifSemibold(17))
                    .foregroundColor(MagazineColors.textPrimary)

                Text(event.subtitle)
                    .font(MagazineFont.body)
                    .foregroundColor(MagazineColors.accent)

                Text(event.description)
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(MagazineColors.textSecondary)
                    .lineSpacing(6)
                    .lineLimit(5)

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(MagazineColors.surfaceAlt)
                        .frame(height: 48)
                    Text(event.imageLabel)
                        .font(MagazineFont.monoBold(12))
                        .foregroundColor(MagazineColors.textTertiary)
                        .tracking(2)
                }
            }
        }
        .padding(.bottom, isLast ? 0 : 28)
    }
}
