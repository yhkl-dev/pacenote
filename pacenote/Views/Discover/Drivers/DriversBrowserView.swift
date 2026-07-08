import SwiftUI

struct DriversBrowserView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("车手与车队")
                    .font(MagazineFont.serifBold(28))
                    .foregroundColor(MagazineColors.textPrimary)

                VStack(spacing: 0) {
                    ForEach(driverList) { driver in
                        NavigationLink(destination: DriverProfileView(driverId: driver.id)) {
                            DriverBrowserRow(driver: driver)
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

    private var driverList: [DriverPreview] {
        [
            DriverPreview(id: "rovanpera", name: "Kalle Rovanperä", team: "Toyota Gazoo Racing", car: "GR Yaris Rally1", number: 69, nationality: "芬兰"),
            DriverPreview(id: "neuville", name: "Thierry Neuville", team: "Hyundai Shell Mobis", car: "i20 N Rally1", number: 11, nationality: "比利时"),
            DriverPreview(id: "tanak", name: "Ott Tänak", team: "Hyundai Shell Mobis", car: "i20 N Rally1", number: 8, nationality: "爱沙尼亚"),
            DriverPreview(id: "evans", name: "Elfyn Evans", team: "Toyota Gazoo Racing", car: "GR Yaris Rally1", number: 33, nationality: "英国"),
            DriverPreview(id: "katsuta", name: "Takamoto Katsuta", team: "Toyota Gazoo Racing", car: "GR Yaris Rally1", number: 18, nationality: "日本"),
            DriverPreview(id: "fourmaux", name: "Adrien Fourmaux", team: "M-Sport Ford", car: "Puma Rally1", number: 16, nationality: "法国"),
            DriverPreview(id: "lappi", name: "Esapekka Lappi", team: "Hyundai Shell Mobis", car: "i20 N Rally1", number: 4, nationality: "芬兰"),
            DriverPreview(id: "munster", name: "Grégoire Munster", team: "M-Sport Ford", car: "Puma Rally1", number: 13, nationality: "卢森堡"),
        ]
    }
}

struct DriverPreview: Identifiable {
    let id: String
    let name: String
    let team: String
    let car: String
    let number: Int
    let nationality: String
}

struct DriverBrowserRow: View {
    let driver: DriverPreview

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(MagazineColors.surfaceAlt)
                    .frame(width: 40, height: 40)
                Text("\(driver.number)")
                    .font(MagazineFont.monoBold(14))
                    .foregroundColor(MagazineColors.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(driver.name)
                    .font(MagazineFont.body.weight(.medium))
                    .foregroundColor(MagazineColors.textPrimary)
                Text("\(driver.nationality) · \(driver.team)")
                    .font(MagazineFont.caption)
                    .foregroundColor(MagazineColors.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(MagazineColors.textTertiary)
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Rectangle().fill(MagazineColors.divider).frame(height: 0.5)
        }
    }
}
