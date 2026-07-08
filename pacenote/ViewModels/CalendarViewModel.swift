import Foundation
import Observation

@MainActor
@Observable
final class CalendarViewModel {
    var events: [RallyEvent] = []
    var isLoading = false
    var errorMessage: String?

    var dataSource: DataSourceMode = .auto
    private let apiClient = APIClient.shared

    func loadSeasonCalendar() async {
        isLoading = true
        errorMessage = nil

        do {
            if dataSource == .mock {
                events = await MockDataService.shared.seasonCalendar()
            } else {
                let raw = try await apiClient.fetchRaw("/api/calendar")
                let events = try decodeCalendar(raw)
                self.events = events
            }
        } catch {
            events = await MockDataService.shared.seasonCalendar()
        }

        isLoading = false
    }

    private func decodeCalendar(_ data: Data) throws -> [RallyEvent] {
        let decoder = JSONDecoder()
        let isoFormatter = ISO8601DateFormatter()

        let translation = TranslationService.shared

        if let array = try? decoder.decode([CalendarEventDTO].self, from: data) {
            return array.map { $0.toModel(isoFormatter: isoFormatter, translation: translation) }
        }

        let response = try decoder.decode(SeasonCalendarResponse.self, from: data)
        return response.events.map { $0.toModel(isoFormatter: isoFormatter, translation: translation) }
    }

    var liveEvents: [RallyEvent] {
        events.filter { $0.status == .live }
    }

    var upcomingEvents: [RallyEvent] {
        events.filter { $0.status == .upcoming }
    }

    var completedEvents: [RallyEvent] {
        events.filter { $0.status == .completed }
    }
}

struct SeasonCalendarResponse: Decodable {
    let events: [CalendarEventDTO]
}

struct CNFields: Decodable {
    let name: String?
    let status: String?
    let surface: String?
    let stageType: String?
    let group: String?
    let nationality: String?
    let country: String?
}

struct CalendarEventDTO: Decodable {
    let eventId: String
    let name: String
    let country: String
    let surface: String
    let startDate: String
    let endDate: String
    let status: String?
    let season: Int?
    let roundNumber: Int?
    let _cn: CNFields?

    func toModel(isoFormatter: ISO8601DateFormatter, translation: TranslationService) -> RallyEvent {
        let start = isoFormatter.date(from: startDate) ?? Date()
        let end = isoFormatter.date(from: endDate) ?? Date()

        let cnName = _cn?.name ?? translation.translateRallyName(name)
        let cnCountry = _cn?.country ?? translation.translateCountry(country)
        let cnSurface = _cn?.surface ?? translation.translateSurface(surface)

        return RallyEvent(
            eventId: eventId,
            name: name,
            nameCN: cnName,
            country: country,
            countryCN: cnCountry,
            surface: surface,
            surfaceCN: cnSurface,
            startDate: start,
            endDate: end,
            statusRaw: status ?? "upcoming",
            season: season ?? Calendar.current.component(.year, from: Date()),
            roundNumber: roundNumber ?? 0
        )
    }
}
