import Foundation

struct Standing: Identifiable, Codable {
    var id: String { standingId }
    var standingId: String
    var season: Int
    var category: String
    var position: Int
    var previousPosition: Int?
    var driverName: String
    var driverId: String
    var team: String
    var carName: String
    var points: Double
    var eventPoints: String

    var positionChange: Int {
        guard let prev = previousPosition else { return 0 }
        return prev - position
    }
}

enum StandingCategory: String, CaseIterable {
    case drivers = "drivers"
    case codrivers = "codrivers"
    case manufacturers = "manufacturers"

    var displayName: String {
        switch self {
        case .drivers: return L10n.Standing.drivers
        case .codrivers: return L10n.Standing.codrivers
        case .manufacturers: return L10n.Standing.manufacturers
        }
    }
}
