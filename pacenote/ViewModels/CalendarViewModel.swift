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
            let raw = try await apiClient.fetchRaw("/api/seasons")
            let decoded = try JSONDecoder().decode(SportradarSeasonsResponse.self, from: raw)
            let wrcSeasons = decoded.stages.filter { isWRC($0) }
            events = try await resolveEvents(from: wrcSeasons)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func isWRC(_ season: SportradarSeason) -> Bool {
        season.description.lowercased().contains("world rally championship")
    }

    private func resolveEvents(from seasons: [SportradarSeason]) async throws -> [RallyEvent] {
        let isoFormatter = ISO8601DateFormatter()
        var allEvents: [RallyEvent] = []

        for season in seasons {
            let start = isoFormatter.date(from: season.scheduled) ?? Date()
            let end = isoFormatter.date(from: season.scheduled_end) ?? Date()

            if season.sportEvents.isEmpty {
                let event = RallyEvent(
                    eventId: season.id,
                    name: season.description,
                    nameCN: TranslationService.shared.translateRallyName(season.description),
                    country: "",
                    countryCN: "",
                    surface: "",
                    surfaceCN: "",
                    startDate: start,
                    endDate: end,
                    statusRaw: season.isOngoing ? "live" : (end < Date() ? "completed" : "upcoming"),
                    season: Calendar.current.component(.year, from: start),
                    roundNumber: 0
                )
                allEvents.append(event)
            } else {
                for (index, sportEvent) in season.sportEvents.enumerated() {
                    let eventStart = isoFormatter.date(from: sportEvent.scheduled) ?? Date()
                    let eventEnd = isoFormatter.date(from: sportEvent.scheduledEnd ?? sportEvent.scheduled) ?? eventStart
                    allEvents.append(RallyEvent(
                        eventId: sportEvent.id,
                        name: sportEvent.name,
                        nameCN: TranslationService.shared.translateRallyName(sportEvent.name),
                        country: sportEvent.venue?.countryName ?? "",
                        countryCN: sportEvent.venue?.countryName ?? "",
                        surface: "",
                        surfaceCN: "",
                        startDate: eventStart,
                        endDate: eventEnd,
                        statusRaw: sportEvent.status == "live" ? "live" : (eventEnd < Date() ? "completed" : "upcoming"),
                        season: Calendar.current.component(.year, from: eventStart),
                        roundNumber: index + 1
                    ))
                }
            }
        }

        return allEvents.isEmpty ? await MockDataService.shared.seasonCalendar() : allEvents
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

struct SportradarSeasonsResponse: Decodable {
    let stages: [SportradarSeason]
}

struct SportradarSeason: Decodable {
    let id: String
    let description: String
    let scheduled: String
    let scheduledEnd: String?
    let type: String?
    let sportEvents: [SportradarSportEvent]

    var scheduled_end: String {
        scheduledEnd ?? scheduled
    }

    var isOngoing: Bool {
        let iso = ISO8601DateFormatter()
        let now = Date()
        let start = iso.date(from: scheduled) ?? now
        let end = iso.date(from: scheduled_end) ?? now
        return now >= start && now <= end
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        scheduled = try container.decode(String.self, forKey: .scheduled)
        scheduledEnd = try container.decodeIfPresent(String.self, forKey: .scheduledEnd)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        sportEvents = try container.decodeIfPresent([SportradarSportEvent].self, forKey: .sportEvents) ?? []
    }

    enum CodingKeys: CodingKey {
        case id, description, scheduled, scheduledEnd, type, sportEvents
    }
}

struct SportradarSportEvent: Decodable {
    let id: String
    let name: String
    let scheduled: String
    let scheduledEnd: String?
    let status: String?
    let venue: SportradarVenue?
}

struct SportradarVenue: Decodable {
    let countryName: String?
}
