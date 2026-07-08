import Foundation
import Observation

@MainActor
@Observable
final class StandingsViewModel {
    var driverStandings: [Standing] = []
    var codriverStandings: [Standing] = []
    var manufacturerStandings: [Standing] = []
    var selectedCategory: StandingCategory = .drivers
    var isLoading = false
    var errorMessage: String?

    private let apiClient = APIClient.shared
    private let currentSeason: Int

    var currentStandings: [Standing] {
        switch selectedCategory {
        case .drivers: return driverStandings
        case .codrivers: return codriverStandings
        case .manufacturers: return manufacturerStandings
        }
    }

    init(season: Int? = nil) {
        currentSeason = season ?? Calendar.current.component(.year, from: Date())
    }

    func loadStandings() async {
        isLoading = true
        errorMessage = nil

        do {
            let raw = try await apiClient.fetchRaw("/api/standings/\(currentSeason)")
            let decoded = try JSONDecoder().decode(ChampionshipResponse.self, from: raw)
            mapStandings(decoded)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func mapStandings(_ response: ChampionshipResponse) {
        driverStandings = response.drivers.enumerated().map { index, dto in
            dto.toModel(position: index + 1, season: currentSeason, category: "drivers")
        }
        codriverStandings = response.codrivers.enumerated().map { index, dto in
            dto.toModel(position: index + 1, season: currentSeason, category: "codrivers")
        }
        manufacturerStandings = response.manufacturers.enumerated().map { index, dto in
            dto.toModel(position: index + 1, season: currentSeason, category: "manufacturers")
        }
    }
}

struct ChampionshipResponse: Decodable {
    let drivers: [StandingDTO]
    let codrivers: [StandingDTO]
    let manufacturers: [StandingDTO]
}

struct StandingDTO: Decodable {
    let driverName: String
    let driverId: String
    let team: String
    let carName: String
    let points: Double
    let eventPoints: String?

    func toModel(position: Int, season: Int, category: String) -> Standing {
        Standing(
            standingId: "\(season)-\(category)-\(driverId)",
            season: season,
            category: category,
            position: position,
            driverName: driverName,
            driverId: driverId,
            team: team,
            carName: carName,
            points: points,
            eventPoints: eventPoints ?? ""
        )
    }
}
