import SwiftUI

enum MagazineColors {
    static let background = Color.black
    static let surface = Color(hex: "#0A0A0A")
    static let surfaceAlt = Color(hex: "#111111")
    static let textPrimary = Color(hex: "#FAFAFA")
    static let textSecondary = Color(hex: "#888888")
    static let textTertiary = Color(hex: "#555555")
    static let divider = Color(hex: "#1A1A1A")
    static let accent = Color(hex: "#FF5A1F")
    static let accentMuted = Color(hex: "#FF5A1F").opacity(0.15)
    static let live = Color(hex: "#FF3B30")
    static let liveMuted = Color(hex: "#FF3B30").opacity(0.12)
    static let completed = Color(hex: "#4ADE80")
    static let completedMuted = Color(hex: "#4ADE80").opacity(0.10)
    static let upcoming = Color(hex: "#FBBF24")
    static let upcomingMuted = Color(hex: "#FBBF24").opacity(0.10)
}

enum MagazineFont {
    static func serifBold(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).weight(.bold)
    }
    static func serifSemibold(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif).weight(.semibold)
    }
    static func serifRegular(_ size: CGFloat) -> Font {
        .system(size: size, design: .serif)
    }
    static func monoBold(_ size: CGFloat) -> Font {
        .system(size: size, design: .monospaced).weight(.bold)
    }
    static func monoMedium(_ size: CGFloat) -> Font {
        .system(size: size, design: .monospaced).weight(.medium)
    }
    static let sectionTitle = Font.system(.title2, design: .serif).weight(.bold)
    static let eventName = Font.system(.body, design: .serif).weight(.semibold)
    static let body = Font.body
    static let caption = Font.caption
    static let position = Font.system(.body, design: .monospaced).weight(.bold)
    static let timing = Font.system(.body, design: .monospaced).weight(.semibold)
    static let timingSmall = Font.system(.caption, design: .monospaced).weight(.medium)
    static let points = Font.system(.title3, design: .monospaced).weight(.bold)
}

struct MagazineCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(MagazineColors.surface)
            .overlay(
                Rectangle()
                    .strokeBorder(MagazineColors.divider, lineWidth: 0.5)
            )
    }
}

struct MagazineSectionTitle: View {
    let title: String
    var subtitle: String?

    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(MagazineFont.sectionTitle)
                .foregroundColor(MagazineColors.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textTertiary)
            }
        }
    }
}

extension View {
    func magazineCard() -> some View {
        modifier(MagazineCard())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
