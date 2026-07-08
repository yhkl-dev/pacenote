import SwiftUI

struct MainTabView: View {
    @State private var calendarVM = CalendarViewModel()
    @State private var standingsVM = StandingsViewModel()
    @AppStorage("spoilerFreeMode") private var spoilerFreeMode = true

    var body: some View {
        TabView {
            NavigationStack {
                CalendarView(viewModel: calendarVM)
            }
            .tabItem {
                Label(L10n.Tab.home, systemImage: "calendar")
            }

            NavigationStack {
                StandingsView(viewModel: standingsVM)
            }
            .tabItem {
                Label(L10n.Tab.standings, systemImage: "trophy")
            }

            NavigationStack {
                DiscoverView()
            }
            .tabItem {
                Label(L10n.Tab.discover, systemImage: "magnifyingglass")
            }

            NavigationStack {
                SettingsView(spoilerFreeMode: $spoilerFreeMode)
            }
            .tabItem {
                Label(L10n.Tab.settings, systemImage: "gearshape")
            }
        }
        .tint(MagazineColors.accent)
        .task {
            await calendarVM.loadSeasonCalendar()
            await standingsVM.loadStandings()
        }
    }
}
