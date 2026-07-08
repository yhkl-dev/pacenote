import Foundation
import SwiftData

@Model
final class Driver {
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

    init(
        driverId: String,
        firstName: String,
        lastName: String,
        nationality: String,
        nationalityCN: String = "",
        birthDate: Date? = nil,
        team: String,
        teamCN: String = "",
        group: String,
        carName: String,
        carNumber: Int,
        coDriverName: String? = nil,
        bioShort: String? = nil,
        imageURL: String? = nil
    ) {
        self.driverId = driverId
        self.firstName = firstName
        self.lastName = lastName
        self.nationality = nationality
        self.nationalityCN = nationalityCN
        self.birthDate = birthDate
        self.team = team
        self.teamCN = teamCN
        self.group = group
        self.carName = carName
        self.carNumber = carNumber
        self.coDriverName = coDriverName
        self.bioShort = bioShort
        self.imageURL = imageURL
    }
}

struct CareerStat: Codable, Identifiable {
    var id: String { "\(driverId)-\(statType)" }
    let driverId: String
    let statType: String
    let value: Int
    let label: String
}
