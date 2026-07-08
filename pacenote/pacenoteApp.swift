import SwiftUI
import SwiftData

@main
struct pacenoteApp: App {
    @AppStorage("appLanguage") private var appLanguage = "zh-Hans"

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RallyEvent.self,
            Stage.self,
            StageResult.self,
            Driver.self,
            Standing.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
                .environment(\.locale, Locale(identifier: appLanguage))
        }
        .modelContainer(sharedModelContainer)
    }
}
