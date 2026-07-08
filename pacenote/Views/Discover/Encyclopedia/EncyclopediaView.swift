import SwiftUI

struct EncyclopediaView: View {
    @State private var selectedCategory: EncyclopediaArticle.ArticleCategory? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("拉力百科")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        CategoryChip(
                            label: "全部",
                            isSelected: selectedCategory == nil
                        ) { selectedCategory = nil }

                        ForEach(EncyclopediaArticle.ArticleCategory.allCases, id: \.rawValue) { cat in
                            CategoryChip(
                                label: cat.displayName,
                                isSelected: selectedCategory == cat
                            ) { selectedCategory = cat }
                        }
                    }
                    .padding(.horizontal, 2)
                }

                VStack(spacing: 0) {
                    ForEach(EncyclopediaData.articles(for: selectedCategory)) { article in
                        NavigationLink(destination: ArticleView(article: article)) {
                            ArticleRow(article: article)
                        }
                        .buttonStyle(.plain)
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

struct CategoryChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(MagazineFont.monoMedium(11))
                .foregroundColor(isSelected ? MagazineColors.background : MagazineColors.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? MagazineColors.accent : MagazineColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(isSelected ? Color.clear : MagazineColors.divider, lineWidth: 0.5)
                )
        }
    }
}

struct ArticleRow: View {
    let article: EncyclopediaArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(article.category.displayName)
                    .font(MagazineFont.monoMedium(9))
                    .foregroundColor(MagazineColors.accent)
                    .tracking(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(MagazineColors.accent.opacity(0.12))

                Text("\(article.readingTime) 分钟")
                    .font(MagazineFont.monoMedium(10))
                    .foregroundColor(MagazineColors.textTertiary)
            }

            Text(article.title)
                .font(MagazineFont.serifSemibold(17))
                .foregroundColor(MagazineColors.textPrimary)

            Text(article.subtitle)
                .font(MagazineFont.caption)
                .foregroundColor(MagazineColors.textSecondary)
                .lineLimit(2)
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }
}
