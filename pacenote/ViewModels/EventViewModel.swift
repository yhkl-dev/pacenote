import Foundation
import Observation

@MainActor
@Observable
final class EventViewModel {
    var overallStandings: [StageResult] = []
    var stages: [Stage] = []
    var selectedStageResults: [StageResult] = []
    var selectedStageMeta: StageMetadata?
    var isLoading = false
    var errorMessage: String?

    var maxGapSeconds: Double {
        guard let last = overallStandings.last else { return 1 }
        let gapStr = last.diffFirst.replacingOccurrences(of: "+", with: "")
        return parseGapToSeconds(gapStr)
    }

    private let apiClient = APIClient.shared

    func loadEventDetail(eventId: String) async {
        isLoading = true
        errorMessage = nil

        do {
            async let stagesTask = fetchStages(eventId: eventId)
            async let overallTask = fetchOverall(eventId: eventId)
            let (fetchedStages, fetchedOverall) = try await (stagesTask, overallTask)
            stages = fetchedStages
            overallStandings = fetchedOverall
        } catch {
            let mock = MockDataService.shared
            stages = await mock.stages(for: eventId)
            overallStandings = await mock.overallStandings()
        }

        isLoading = false
    }

    func loadStageResults(eventId: String, stageId: String) async {
        do {
            let raw = try await apiClient.fetchRaw("/results-api/rally-event/\(eventId)/stage-result/\(stageId)")
            let decoded = try JSONDecoder().decode(StageResultsResponse.self, from: raw)
            selectedStageResults = decoded.results.map { $0.toModel(stageId: stageId) }
        } catch {
            selectedStageResults = await MockDataService.shared.stageResults(stageId: stageId)
        }
    }

    func loadStageMeta(stageId: String) async {
        selectedStageMeta = await MockDataService.shared.stageMeta(stageId: stageId)
    }

    private func fetchStages(eventId: String) async throws -> [Stage] {
        let raw = try await apiClient.fetchRaw("/results-api/rally-event/\(eventId)/itinerary")
        let decoded = try JSONDecoder().decode(ItineraryResponse.self, from: raw)
        return decoded.stages.map { $0.toModel(eventId: eventId) }
    }

    private func fetchOverall(eventId: String) async throws -> [StageResult] {
        let raw = try await apiClient.fetchRaw("/results-api/rally-event/\(eventId)/overall")
        let decoded = try JSONDecoder().decode(StageResultsResponse.self, from: raw)
        return decoded.results.map { $0.toModel(stageId: "overall") }
    }

    func gapRatio(for diffFirst: String) -> Double {
        let seconds = parseGapToSeconds(diffFirst.replacingOccurrences(of: "+", with: ""))
        let max = maxGapSeconds > 0 ? maxGapSeconds : 1
        return min(seconds / max, 1.0)
    }

    func parseGapToSeconds(_ gap: String) -> Double {
        if gap == "—" || gap.isEmpty { return 0 }
        let parts = gap.components(separatedBy: ":")
        if parts.count == 2, let min = Double(parts[0]), let sec = Double(parts[1]) {
            return min * 60 + sec
        }
        return Double(gap) ?? 0
    }
}

struct ItineraryResponse: Decodable {
    let stages: [StageDTO]
}

struct StageDTO: Decodable {
    let stageId: String; let name: String; let stageNumber: Int
    let distance: Double?; let surface: String?; let status: String?
    let startTime: String?; let firstCarTime: String?

    func toModel(eventId: String) -> Stage {
        let translation = TranslationService.shared
        let isoFormatter = ISO8601DateFormatter()
        return Stage(stageId: stageId, eventId: eventId, name: name, stageNumber: stageNumber, distance: distance ?? 0, surface: surface ?? "", surfaceCN: surface.map { translation.translateSurface($0) } ?? "", statusRaw: status ?? "upcoming", startTime: startTime.flatMap { isoFormatter.date(from: $0) }, firstCarTime: firstCarTime.flatMap { isoFormatter.date(from: $0) })
    }
}

struct StageResultsResponse: Decodable {
    let results: [StageResultDTO]
}

struct StageResultDTO: Decodable {
    let position: Int; let driverName: String; let driverId: String
    let carNumber: Int; let group: String; let stageTime: String
    let diffFirst: String; let diffPrev: String; let speed: Double?
    func toModel(stageId: String) -> StageResult {
        StageResult(stageId: stageId, position: position, driverName: driverName, driverId: driverId, carNumber: carNumber, group: group, stageTime: stageTime, diffFirst: diffFirst, diffPrev: diffPrev, speed: speed)
    }
}
