import Foundation

struct RallyEvent: Identifiable, Codable {
    var id: String { eventId }
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
    var isERC: Bool = false
    var coverImageURL: String? = nil
    var websiteURL: String? = nil

    var displayName: String {
        nameCN.isEmpty ? name : nameCN
    }

    var status: EventStatus {
        EventStatus(rawValue: statusRaw) ?? .upcoming
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
