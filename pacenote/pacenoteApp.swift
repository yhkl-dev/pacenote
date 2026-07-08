import SwiftUI

@main
struct pacenoteApp: App {
    @AppStorage("appLanguage") private var appLanguage = "zh-Hans"

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
                .environment(\.locale, Locale(identifier: appLanguage))
        }
    }
}
