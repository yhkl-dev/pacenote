import Foundation

enum DataSourceMode {
    case auto
    case mock
}

actor APIClient {
    static let shared = APIClient()

    private let workerBaseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder

    var dataSource: DataSourceMode = .auto

    private init() {
        workerBaseURL = APIClient.resolveWorkerURL()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.waitsForConnectivity = true
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    private static func resolveWorkerURL() -> String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
            return url
        }
        return "https://pacenote.visionary-future.com"
    }

    var baseURL: String {
        workerBaseURL
    }
}

extension APIClient {
    func fetch<T: Decodable>(_ endpoint: String, as type: T.Type) async throws -> T {
        let url = URL(string: "\(workerBaseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    func fetchRaw(_ endpoint: String) async throws -> Data {
        let url = URL(string: "\(workerBaseURL)\(endpoint)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        return data
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case httpError(Int)
    case decodingFailed(Error)
    case noConnection

    var errorDescription: String? {
        switch self {
        case .invalidResponse: return L10n.Error.server
        case .httpError(let code): return "\(L10n.Error.server) (\(code))"
        case .decodingFailed: return L10n.Error.decoding
        case .noConnection: return L10n.Error.network
        }
    }
}
