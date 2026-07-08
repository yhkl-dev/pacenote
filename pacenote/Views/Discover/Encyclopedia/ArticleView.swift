import SwiftUI

struct ArticleView: View {
    let article: EncyclopediaArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text(article.category.rawValue)
                            .font(MagazineFont.monoMedium(10))
                            .foregroundColor(MagazineColors.accent)
                            .tracking(1)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(MagazineColors.accent.opacity(0.12))

                        Text("\(article.readingTime) 分钟阅读")
                            .font(MagazineFont.monoMedium(10))
                            .foregroundColor(MagazineColors.textTertiary)
                    }

                    Text(article.title)
                        .font(MagazineFont.serifBold(28))
                        .foregroundColor(MagazineColors.textPrimary)

                    Text(article.subtitle)
                        .font(MagazineFont.body)
                        .foregroundColor(MagazineColors.textSecondary)
                }

                Rectangle()
                    .fill(MagazineColors.divider)
                    .frame(height: 0.5)

                MarkdownBody(text: article.body)
            }
            .padding(20)
        }
        .background(MagazineColors.background)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MarkdownBody: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(blocks.enumerated()), id: \.offset) { _, block in
                switch block {
                case .heading(let content):
                    Text(content)
                        .font(MagazineFont.serifBold(18))
                        .foregroundColor(MagazineColors.textPrimary)
                        .padding(.top, 8)

                case .paragraph(let content):
                    MarkdownText(content)
                        .lineSpacing(8)

                case .bullet(let items):
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 8) {
                                Text("·")
                                    .font(.system(size: 15, design: .monospaced).weight(.bold))
                                    .foregroundColor(MagazineColors.accent)
                                MarkdownText(item)
                                    .lineSpacing(6)
                            }
                        }
                    }
                    .padding(.leading, 4)
                }
            }
        }
        .padding(.top, 4)
    }

    private var blocks: [MarkdownBlock] {
        MarkdownParser.parse(text)
    }
}

enum MarkdownBlock {
    case heading(String)
    case paragraph(String)
    case bullet([String])
}

enum MarkdownParser {
    static func parse(_ text: String) -> [MarkdownBlock] {
        var blocks: [MarkdownBlock] = []
        var currentBullets: [String] = []
        var currentParagraph: [String] = []

        let lines = text.components(separatedBy: "\n")

        func flushParagraph() {
            if !currentParagraph.isEmpty {
                let content = currentParagraph
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                    .filter { !$0.isEmpty }
                    .joined(separator: " ")
                if !content.isEmpty {
                    blocks.append(.paragraph(content))
                }
                currentParagraph = []
            }
        }

        func flushBullets() {
            if !currentBullets.isEmpty {
                blocks.append(.bullet(currentBullets))
                currentBullets = []
            }
        }

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("## ") {
                flushParagraph()
                flushBullets()
                let content = String(trimmed.dropFirst(3))
                blocks.append(.heading(content))
            } else if trimmed.hasPrefix("- ") {
                flushParagraph()
                let content = String(trimmed.dropFirst(2))
                currentBullets.append(content)
            } else if trimmed.isEmpty {
                flushParagraph()
                flushBullets()
            } else {
                flushBullets()
                currentParagraph.append(trimmed)
            }
        }

        flushParagraph()
        flushBullets()

        return blocks
    }
}

struct MarkdownText: View {
    let source: String

    init(_ source: String) {
        self.source = source
    }

    var body: some View {
        if let attributed = try? AttributedString(
            markdown: source,
            options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        ) {
            Text(attributed)
                .font(.system(size: 15, design: .serif))
                .foregroundColor(MagazineColors.textPrimary)
        } else {
            Text(source)
                .font(.system(size: 15, design: .serif))
                .foregroundColor(MagazineColors.textPrimary)
        }
    }
}
