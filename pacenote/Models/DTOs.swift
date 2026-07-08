import Foundation

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

    var scheduled_end: String { scheduledEnd ?? scheduled }
}

struct RallyVenueDTO: Decodable {
    let name: String?
    let city: String?
    let country: String?
    let countryCode: String?
    let coordinates: String?
    let timezone: String?

    enum CodingKeys: String, CodingKey {
        case name, city, country, timezone, coordinates
        case countryCode = "country_code"
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

    var scheduled_end: String { scheduledEnd ?? scheduled }
}

func guessSurface(country: String) -> String {
    switch country {
    case "Sweden": return "Snow"
    case "Monaco", "France": return "Mixed"
    case "Kenya", "Portugal", "Italy", "Greece", "Estonia", "Finland", "Chile", "Paraguay", "Saudi Arabia": return "Gravel"
    case "Japan", "Croatia", "Belgium", "Spain", "Germany", "Austria", "Czech Republic", "Poland": return "Tarmac"
    default: return ""
    }
}
