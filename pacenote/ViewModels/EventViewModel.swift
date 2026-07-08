import Foundation
import Observation

@MainActor
@Observable
final class EventViewModel {
    var overallStandings: [StageResult] = []
    var stages: [Stage] = []
    var selectedStageResults: [StageResult] = []
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
            let (s, o) = try await (stagesTask, overallTask)
            stages = s
            overallStandings = o
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadStageResults(eventId: String, stageId: String) async {
        do {
            let raw = try await apiClient.fetchRaw("/api/event/\(eventId)/stage/\(stageId)")
            let decoded = try JSONDecoder().decode(StageResultsResponse.self, from: raw)
            selectedStageResults = decoded.results.map { $0.toModel(stageId: stageId) }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetchStages(eventId: String) async throws -> [Stage] {
        let raw = try await apiClient.fetchRaw("/api/event/\(eventId)/stages")
        let decoded = try JSONDecoder().decode(ScheduleResponse.self, from: raw)
        return decoded.stages.map { $0.toStageModel(eventId: eventId) }
    }

    private func fetchOverall(eventId: String) async throws -> [StageResult] {
        let raw = try await apiClient.fetchRaw("/api/event/\(eventId)/summary")
        let decoded = try JSONDecoder().decode(SportradarSummaryResponse.self, from: raw)
        return decoded.results
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

extension RallyStageDTO {
    func toStageModel(eventId: String) -> Stage {
        let isoFormatter = ISO8601DateFormatter()
        let start = isoFormatter.date(from: scheduled) ?? Date()
        return Stage(
            stageId: id,
            eventId: eventId,
            name: description,
            stageNumber: 0,
            distance: 0,
            surface: "",
            surfaceCN: "",
            statusRaw: status ?? "upcoming",
            startTime: start
        )
    }
}

struct SportradarSummaryResponse: Decodable {
    let results: [StageResult]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let stage = try container.decode(StageWithCompetitors.self, forKey: .stage)
        results = stage.competitors.map { comp in
            StageResult(
                stageId: "overall",
                position: comp.result.position,
                driverName: comp.name,
                driverId: comp.id,
                carNumber: comp.carNumber ?? 0,
                group: "",
                stageTime: comp.result.gap ?? "—",
                diffFirst: comp.result.gap ?? "—",
                diffPrev: ""
            )
        }
    }

    enum CodingKeys: String, CodingKey {
        case stage
    }
}

struct StageWithCompetitors: Decodable {
    let competitors: [SRCompetitor]

    enum CodingKeys: String, CodingKey {
        case competitors
    }
}

struct SRCompetitor: Decodable {
    let id: String
    let name: String
    let carNumber: Int?
    let result: SRResult

    enum CodingKeys: String, CodingKey {
        case id, name, result
        case carNumber = "car_number"
    }
}

struct SRResult: Decodable {
    let position: Int
    let points: Double?
    let status: String?
    let gap: String?
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
