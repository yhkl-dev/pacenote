import SwiftUI

struct SettingsView: View {
    @Binding var spoilerFreeMode: Bool
    @AppStorage("appLanguage") private var appLanguage = "zh-Hans"
    @State private var notificationsEnabled = false
    @State private var showLanguagePicker = false

    private var currentLanguageLabel: String {
        LocaleOption.from(appLanguage).nativeName
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                sectionTitle(L10n.Settings.preferences)
                VStack(spacing: 0) {
                    SettingToggle(
                        icon: "eye.slash",
                        title: L10n.Spoiler.title,
                        subtitle: L10n.Spoiler.description,
                        isOn: $spoilerFreeMode
                    )
                    Divider().background(MagazineColors.divider).padding(.leading, 44)
                    SettingToggle(
                        icon: "bell",
                        title: L10n.Settings.notifications,
                        subtitle: L10n.Settings.notificationsDesc,
                        isOn: $notificationsEnabled
                    )
                }
                .magazineCard()

                sectionTitle(L10n.Settings.general)
                VStack(spacing: 0) {
                    Button {
                        showLanguagePicker = true
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "globe")
                                .font(.body)
                                .foregroundColor(MagazineColors.accent)
                                .frame(width: 20)
                            Text(L10n.Settings.language)
                                .font(MagazineFont.body)
                                .foregroundColor(MagazineColors.textPrimary)
                            Spacer()
                            Text(currentLanguageLabel)
                                .font(MagazineFont.monoMedium(12))
                                .foregroundColor(MagazineColors.textSecondary)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundColor(MagazineColors.textTertiary)
                        }
                        .padding(16)
                    }
                    .buttonStyle(.plain)
                }
                .magazineCard()

                sectionTitle(L10n.Settings.about)
                VStack(spacing: 0) {
                    SettingInfo(icon: "info.circle", title: L10n.Settings.aboutPacenote, value: "v1.0.0")
                    Divider().background(MagazineColors.divider).padding(.leading, 44)
                    SettingInfo(icon: "link", title: L10n.Settings.dataSource, value: L10n.Settings.dataSourceValue)
                }
                .magazineCard()
            }
            .padding(20)
        }
        .background(MagazineColors.background)
        .navigationTitle(L10n.Nav.settings)
        .navigationBarTitleDisplayMode(.large)
        .confirmationDialog(L10n.Settings.language, isPresented: $showLanguagePicker) {
            ForEach(LocaleOption.all) { option in
                Button(option.nativeName) { appLanguage = option.code }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(MagazineFont.monoBold(10))
            .foregroundColor(MagazineColors.accent)
            .tracking(2)
    }
}

struct SettingToggle: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(MagazineColors.accent)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                Text(subtitle)
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(MagazineColors.accent)
                .labelsHidden()
        }
        .padding(16)
    }
}

struct SettingInfo: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(MagazineColors.textSecondary)
                .frame(width: 20)

            Text(title)
                .font(MagazineFont.body)
                .foregroundColor(MagazineColors.textPrimary)

            Spacer()

            Text(value)
                .font(MagazineFont.monoMedium(12))
                .foregroundColor(MagazineColors.textTertiary)
        }
        .padding(16)
    }
}
