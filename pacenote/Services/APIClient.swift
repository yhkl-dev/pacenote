import Foundation

actor APIClient {
    static let shared = APIClient()

    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder

    private init() {
        baseURL = APIClient.resolveBaseURL()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.waitsForConnectivity = true
        session = URLSession(configuration: config)
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    private static func resolveBaseURL() -> String {
        if let url = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String {
            return url
        }
        return "https://api.wrc.com"
    }
}

extension APIClient {
    func fetch<T: Decodable>(_ endpoint: String, as type: T.Type) async throws -> T {
        let url = URL(string: "\(baseURL)\(endpoint)")!
        let (data, response) = try await session.data(from: url)

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
        let url = URL(string: "\(baseURL)\(endpoint)")!
        let (data, response) = try await session.data(from: url)

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
        case .invalidResponse: return "服务器响应无效"
        case .httpError(let code): return "服务器错误 (\(code))"
        case .decodingFailed: return "数据解析失败"
        case .noConnection: return "网络连接不可用"
        }
    }
}
