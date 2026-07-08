import Foundation
import SwiftData

@Model
final class Standing {
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

    init(
        standingId: String,
        season: Int,
        category: String,
        position: Int,
        previousPosition: Int? = nil,
        driverName: String,
        driverId: String,
        team: String,
        carName: String,
        points: Double,
        eventPoints: String
    ) {
        self.standingId = standingId
        self.season = season
        self.category = category
        self.position = position
        self.previousPosition = previousPosition
        self.driverName = driverName
        self.driverId = driverId
        self.team = team
        self.carName = carName
        self.points = points
        self.eventPoints = eventPoints
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
