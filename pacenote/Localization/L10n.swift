import Foundation

struct LocaleOption: Identifiable, Hashable {
    let id: String
    let code: String
    let nativeName: String

    func hash(into hasher: inout Hasher) { hasher.combine(code) }
    static func == (lhs: LocaleOption, rhs: LocaleOption) -> Bool { lhs.code == rhs.code }

    static let all: [LocaleOption] = [
        LocaleOption(id: "简体中文", code: "zh-Hans", nativeName: "简体中文"),
        LocaleOption(id: "繁體中文", code: "zh-Hant", nativeName: "繁體中文"),
        LocaleOption(id: "English", code: "en", nativeName: "English"),
        LocaleOption(id: "日本語", code: "ja", nativeName: "日本語"),
        LocaleOption(id: "Suomi", code: "fi", nativeName: "Suomi"),
        LocaleOption(id: "Français", code: "fr", nativeName: "Français"),
        LocaleOption(id: "Español", code: "es", nativeName: "Español"),
        LocaleOption(id: "Deutsch", code: "de", nativeName: "Deutsch"),
    ]

    static func from(_ code: String) -> LocaleOption {
        all.first { $0.code == code } ?? all[0]
    }
}

enum L10n {
    enum Tab {
        static let home = String(localized: "tab.home")
        static let standings = String(localized: "tab.standings")
        static let discover = String(localized: "tab.discover")
        static let settings = String(localized: "tab.settings")
    }

    enum Nav {
        static let standings = String(localized: "nav.standings")
        static let eventDetail = String(localized: "nav.eventDetail")
        static let driverProfile = String(localized: "nav.driverProfile")
        static let discover = String(localized: "nav.discover")
        static let settings = String(localized: "nav.settings")
    }

    enum Status {
        static let upcoming = String(localized: "status.upcoming")
        static let live = String(localized: "status.live")
        static let completed = String(localized: "status.completed")
        static let cancelled = String(localized: "status.cancelled")
    }

    enum Section {
        static let live = String(localized: "section.live")
        static let upcoming = String(localized: "section.upcoming")
        static let completed = String(localized: "section.completed")
    }

    enum Event {
        static let overall = String(localized: "event.tab.overall")
        static let stages = String(localized: "event.tab.stages")
        static let entries = String(localized: "event.tab.entries")
        static let schedule = String(localized: "event.tab.schedule")
        static let round = String(localized: "event.round")
        static let leaderHint = String(localized: "event.leaderHint")
    }

    enum Standing {
        static let drivers = String(localized: "standing.drivers")
        static let codrivers = String(localized: "standing.codrivers")
        static let manufacturers = String(localized: "standing.manufacturers")
    }

    enum Spoiler {
        static let title = String(localized: "spoiler.title")
        static let enabled = String(localized: "spoiler.enabled")
        static let description = String(localized: "spoiler.description")
        static let reveal = String(localized: "spoiler.reveal")
        static let hidden = String(localized: "spoiler.hidden")
        static func eventLive(_ name: String) -> String {
            "\(name) \(String(localized: "spoiler.eventLive"))"
        }
    }

    enum Settings {
        static let preferences = String(localized: "settings.preferences")
        static let notifications = String(localized: "settings.notifications")
        static let notificationsDesc = String(localized: "settings.notificationsDesc")
        static let general = String(localized: "settings.general")
        static let language = String(localized: "settings.language")
        static let about = String(localized: "settings.about")
        static let aboutPacenote = String(localized: "settings.aboutPacenote")
        static let dataSource = String(localized: "settings.dataSource")
        static let dataSourceValue = String(localized: "settings.dataSourceValue")
    }

    enum Stage {
        static let info = String(localized: "stage.info")
        static let notStarted = String(localized: "stage.notStarted")
        static let noResults = String(localized: "stage.noResults")
        static let distance = String(localized: "stage.distance")
        static let surface = String(localized: "stage.surface")
        static let weather = String(localized: "stage.weather")
        static let elevation = String(localized: "stage.elevation")
        static let historicalBest = String(localized: "stage.historicalBest")
        static let sunny = String(localized: "stage.sunny")
        static let cloudy = String(localized: "stage.cloudy")
        static let rain = String(localized: "stage.rain")
        static let snow = String(localized: "stage.snow")
    }

    enum Driver {
        static let career = String(localized: "driver.career")
        static let currentSeason = String(localized: "driver.currentSeason")
        static let starts = String(localized: "driver.starts")
        static let titles = String(localized: "driver.titles")
        static let wins = String(localized: "driver.wins")
        static let podiums = String(localized: "driver.podiums")
        static let winRate = String(localized: "driver.winRate")
        static let podiumRate = String(localized: "driver.podiumRate")
        static let highlights = String(localized: "driver.highlights")
    }

    enum Discover {
        static let title = String(localized: "discover.title")
        static let comingSoon = String(localized: "discover.comingSoon")
        static let encyclopedia = String(localized: "discover.encyclopedia")
        static let encyclopediaDesc = String(localized: "discover.encyclopediaDesc")
        static let drivers = String(localized: "discover.drivers")
        static let driversDesc = String(localized: "discover.driversDesc")
        static let history = String(localized: "discover.history")
        static let historyDesc = String(localized: "discover.historyDesc")
        static let gameTracks = String(localized: "discover.gameTracks")
        static let gameTracksDesc = String(localized: "discover.gameTracksDesc")
        static let minRead = String(localized: "discover.minRead")
        static let all = String(localized: "discover.all")
        static let basics = String(localized: "discover.basics")
        static let rules = String(localized: "discover.rules")
        static let tech = String(localized: "discover.tech")
        static let pacenotes = String(localized: "discover.pacenotes")
    }

    enum GameTracks {
        static let title = String(localized: "gameTracks.title")
        static let description = String(localized: "gameTracks.description")
    }

    enum Loading {
        static let `default` = String(localized: "loading.default")
        static let entries = String(localized: "loading.entries")
        static let schedule = String(localized: "loading.schedule")
        static let driverData = String(localized: "loading.driverData")
    }

    enum Empty {
        static let calendar = String(localized: "empty.calendar")
        static let standings = String(localized: "empty.standings")
    }

    enum Error {
        static let network = String(localized: "error.network")
        static let server = String(localized: "error.server")
        static let decoding = String(localized: "error.decoding")
        static let retry = String(localized: "error.retry")
    }
}
