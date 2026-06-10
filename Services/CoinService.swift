//
//  CoinService.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 26.05.26.
//

import Foundation

protocol CoinServiceProtocol {
    func fetchCoins() async throws -> [Coin]
}

private enum CoinGeckoAPI {
    static let scheme = "https"
    static let host = "api.coingecko.com"
    static let coinsMarketsPath = "/api/v3/coins/markets"

    static func coinsMarketsURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = coinsMarketsPath
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: "50"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sparkline", value: "true"),
            URLQueryItem(name: "price_change_percentage", value: "24h")
        ]

        return components.url
    }
}

final class CoinService: CoinServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private var cachedCoins: [Coin] = []
    private var lastFetchTime: Date?
    private let cacheValidityDuration: TimeInterval = 60
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCoins() async throws -> [Coin] {
        // Use cache if valid
        if let lastFetch = lastFetchTime,
           Date().timeIntervalSince(lastFetch) < cacheValidityDuration,
           !cachedCoins.isEmpty {
            return cachedCoins
        }
        
        guard let url = CoinGeckoAPI.coinsMarketsURL() else {
            throw NetworkError.invalidURL
        }
        
        let coins: [Coin] = try await networkService.fetch(from: url)
        cachedCoins = coins
        lastFetchTime = Date()
        return coins
    }
}
