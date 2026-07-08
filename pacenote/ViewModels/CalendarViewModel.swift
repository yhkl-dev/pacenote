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

struct ScheduleResponse: Decodable {
    let stages: [RallyStageDTO]
}

struct RallyStageDTO: Decodable {
    let id: String
    let description: String
    let scheduled: String
    let scheduledEnd: String?
    let status: String?
    let type: String?
    let venue: RallyVenueDTO?
    let stages: [RallyStageDTO]?

    var scheduled_end: String {
        scheduledEnd ?? scheduled
    }

    func toModel() -> RallyEvent {
        let isoFormatter = ISO8601DateFormatter()
        let start = isoFormatter.date(from: scheduled) ?? Date()
        let end = isoFormatter.date(from: scheduled_end) ?? Date()
        let translation = TranslationService.shared

        let eventStatus: String = {
            switch status?.lowercased() {
            case "closed", "completed": return "completed"
            case "live", "running": return "live"
            case "cancelled": return "cancelled"
            default:
                let now = Date()
                if now >= start && now <= end { return "live" }
                return now > end ? "completed" : "upcoming"
            }
        }()

        let country = venue?.country ?? venue?.countryCode ?? ""
        let surface = type == "event" && venue != nil ? guessSurface(country: country) : ""

        return RallyEvent(
            eventId: id,
            name: description,
            nameCN: translation.translateRallyName(description),
            country: country,
            countryCN: translation.translateCountry(country),
            surface: surface,
            surfaceCN: translation.translateSurface(surface),
            startDate: start,
            endDate: end,
            statusRaw: eventStatus,
            season: Calendar.current.component(.year, from: start),
            roundNumber: 0
        )
    }
}

struct RallyVenueDTO: Decodable {
    let name: String?
    let city: String?
    let country: String?
    let countryCode: String?
    let coordinates: String?
    let timezone: String?

    enum CodingKeys: String, CodingKey {
        case name, city, country
        case countryCode = "country_code"
        case coordinates, timezone
    }
}

private func guessSurface(country: String) -> String {
    switch country {
    case "Sweden": return "Snow"
    case "Monaco", "France": return "Mixed"
    case "Kenya", "Portugal", "Italy", "Greece", "Estonia", "Finland", "Chile", "Paraguay", "Saudi Arabia": return "Gravel"
    case "Japan", "Croatia", "Belgium", "Spain", "Germany", "Austria", "Czech Republic", "Poland": return "Tarmac"
    default: return ""
    }
}
