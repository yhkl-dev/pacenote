import Foundation
import SwiftData

@Model
final class Stage {
    var stageId: String
    var eventId: String
    var name: String
    var stageNumber: Int
    var distance: Double
    var surface: String
    var surfaceCN: String
    var statusRaw: String
    var startTime: Date?
    var firstCarTime: Date?

    var status: EventStatus {
        EventStatus(rawValue: statusRaw) ?? .upcoming
    }

    init(
        stageId: String,
        eventId: String,
        name: String,
        stageNumber: Int,
        distance: Double,
        surface: String,
        surfaceCN: String = "",
        statusRaw: String,
        startTime: Date? = nil,
        firstCarTime: Date? = nil
    ) {
        self.stageId = stageId
        self.eventId = eventId
        self.name = name
        self.stageNumber = stageNumber
        self.distance = distance
        self.surface = surface
        self.surfaceCN = surfaceCN
        self.startTime = startTime
        self.firstCarTime = firstCarTime
        self.statusRaw = statusRaw
    }
}

@Model
final class StageResult {
    var stageId: String
    var position: Int
    var driverName: String
    var driverId: String
    var carNumber: Int
    var group: String
    var stageTime: String
    var diffFirst: String
    var diffPrev: String
    var speed: Double?

    init(
        stageId: String,
        position: Int,
        driverName: String,
        driverId: String,
        carNumber: Int,
        group: String,
        stageTime: String,
        diffFirst: String,
        diffPrev: String,
        speed: Double? = nil
    ) {
        self.stageId = stageId
        self.position = position
        self.driverName = driverName
        self.driverId = driverId
        self.carNumber = carNumber
        self.group = group
        self.stageTime = stageTime
        self.diffFirst = diffFirst
        self.diffPrev = diffPrev
        self.speed = speed
    }
}

struct SplitTime: Codable, Identifiable {
    var id: String { "\(stageId)-\(driverId)-\(splitNumber)" }
    let stageId: String
    let driverId: String
    let splitNumber: Int
    let time: String
    let diffFirst: String
}
