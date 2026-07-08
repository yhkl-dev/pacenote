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
            let raw = try await apiClient.fetchRaw("/api/calendar")
            let decoded = try JSONDecoder().decode(ScheduleResponse.self, from: raw)
            events = decoded.stages.map { $0.toModel() }
        } catch {
            errorMessage = error.localizedDescription
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

extension RallyStageDTO {
    func toModel() -> RallyEvent {
        let isoFormatter = ISO8601DateFormatter()
        let start = isoFormatter.date(from: scheduled) ?? Date()
        let end = isoFormatter.date(from: scheduled_end) ?? Date()
        let translation = TranslationService.shared

        let eventStatus: String = normalizeSportradarStatus(status)

        let country = venue?.country ?? venue?.countryCode ?? ""
        let surfaceStr = guessSurface(country: country)

        return RallyEvent(
            eventId: id,
            name: description,
            nameCN: translation.translateRallyName(description),
            country: country,
            countryCN: translation.translateCountry(country),
            surface: surfaceStr,
            surfaceCN: translation.translateSurface(surfaceStr),
            startDate: start,
            endDate: end,
            statusRaw: eventStatus,
            season: Calendar.current.component(.year, from: start),
            roundNumber: 0
        )
    }
}
