import Foundation

struct Driver: Identifiable, Codable {
    var id: String { driverId }
    var driverId: String
    var firstName: String
    var lastName: String
    var nationality: String
    var nationalityCN: String
    var birthDate: Date?
    var team: String
    var teamCN: String
    var group: String
    var carName: String
    var carNumber: Int
    var coDriverName: String?
    var bioShort: String?
    var imageURL: String?

    var displayName: String {
        "\(firstName) \(lastName)"
    }
}

struct CareerStat: Codable, Identifiable {
    var id: String { "\(driverId)-\(statType)" }
    let driverId: String
    let statType: String
    let value: Int
    let label: String
}
