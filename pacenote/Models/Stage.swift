import Foundation

struct Stage: Identifiable, Codable {
    var id: String { stageId }
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
}

struct StageResult: Identifiable, Codable {
    var id: String { "\(stageId)-\(driverId)" }
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
}

struct SplitTime: Codable, Identifiable {
    var id: String { "\(stageId)-\(driverId)-\(splitNumber)" }
    let stageId: String
    let driverId: String
    let splitNumber: Int
    let time: String
    let diffFirst: String
}
