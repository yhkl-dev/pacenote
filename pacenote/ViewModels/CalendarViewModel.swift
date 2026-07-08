import Foundation
import Observation

@MainActor
@Observable
final class CalendarViewModel {
    var events: [RallyEvent] = []
    var isLoading = false
    var errorMessage: String?

    private let apiClient = APIClient.shared

    func loadSeasonCalendar() async {
        isLoading = true
        errorMessage = nil

        do {
            let raw = try await apiClient.fetchRaw("/contel-page/83388/calendar/active-season/")
            let decoded = try JSONDecoder().decode(SeasonCalendarResponse.self, from: raw)
            events = decoded.events.map { $0.toModel() }
        } catch {
            events = await MockDataService.shared.seasonCalendar()
        }

        isLoading = false
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

    func toModel() -> RallyEvent {
        let isoFormatter = ISO8601DateFormatter()
        let start = isoFormatter.date(from: startDate) ?? Date()
        let end = isoFormatter.date(from: endDate) ?? Date()

        let translation = TranslationService.shared
        return RallyEvent(
            eventId: eventId,
            name: name,
            nameCN: translation.translateRallyName(name),
            country: country,
            countryCN: translation.translateCountry(country),
            surface: surface,
            surfaceCN: translation.translateSurface(surface),
            startDate: start,
            endDate: end,
            statusRaw: status ?? "upcoming",
            season: season ?? Calendar.current.component(.year, from: Date()),
            roundNumber: roundNumber ?? 0
        )
    }
}
