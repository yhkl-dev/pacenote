import Foundation
import SwiftData

@Model
final class RallyEvent {
    var eventId: String
    var name: String
    var nameCN: String
    var country: String
    var countryCN: String
    var surface: String
    var surfaceCN: String
    var startDate: Date
    var endDate: Date
    var statusRaw: String
    var season: Int
    var roundNumber: Int
    var isERC: Bool
    var coverImageURL: String?
    var websiteURL: String?

    var displayName: String {
        nameCN.isEmpty ? name : nameCN
    }

    var status: EventStatus {
        EventStatus(rawValue: statusRaw) ?? .upcoming
    }

    init(
        eventId: String,
        name: String,
        nameCN: String = "",
        country: String,
        countryCN: String = "",
        surface: String,
        surfaceCN: String = "",
        startDate: Date,
        endDate: Date,
        statusRaw: String,
        season: Int,
        roundNumber: Int,
        isERC: Bool = false,
        coverImageURL: String? = nil,
        websiteURL: String? = nil
    ) {
        self.eventId = eventId
        self.name = name
        self.nameCN = nameCN
        self.country = country
        self.countryCN = countryCN
        self.surface = surface
        self.surfaceCN = surfaceCN
        self.startDate = startDate
        self.endDate = endDate
        self.statusRaw = statusRaw
        self.season = season
        self.roundNumber = roundNumber
        self.isERC = isERC
        self.coverImageURL = coverImageURL
        self.websiteURL = websiteURL
    }
}

enum EventStatus: String, Codable {
    case upcoming = "upcoming"
    case live = "live"
    case completed = "completed"
    case cancelled = "cancelled"

    var displayName: String {
        switch self {
        case .upcoming: return L10n.Status.upcoming
        case .live: return L10n.Status.live
        case .completed: return L10n.Status.completed
        case .cancelled: return L10n.Status.cancelled
        }
    }

    var color: String {
        switch self {
        case .upcoming: return "#FFB800"
        case .live: return "#FF3B30"
        case .completed: return "#30D158"
        case .cancelled: return "#8E8E93"
        }
    }
}
