//
//  Coin.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 26.05.26.
//

import Foundation

struct Coin: Identifiable, Codable, Hashable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int?
    let totalVolume: Double?
    let highestPrice24h: Double?
    let lowestPrice24h: Double?
    let priceChangePercentage24h: Double?
    let sparklineIn7d: SparklineData?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case highestPrice24h = "high_24h"
        case lowestPrice24h = "low_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case sparklineIn7d = "sparkline_in_7d"
    }
}

struct SparklineData: Codable, Hashable {
    let price: [Double]
}
