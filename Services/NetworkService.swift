//
//  NetworkService..swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 26.05.26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response from server"
        case .decodingError: return "Failed to decode data"
        case .serverError(let code): return "Server error: \(code)"
        }
    }
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(from url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
