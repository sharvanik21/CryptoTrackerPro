//
//  FavoriteRowViewModel.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 10.06.26.
//

import SwiftUI

struct FavoriteRowViewModel {
    
    let enriched: EnrichedFavorite
    
    var name: String {
        enriched.coin.name
    }
    
    var symbol: String {
        enriched.coin.symbol.uppercased()
    }
    
    var imageURL: URL? {
        URL(string: enriched.coin.image)
    }
    
    var sparklinePrices: [Double] {
        enriched.coin.sparklineIn7d?.price ?? []
    }
    
    var hasSparklineData: Bool {
        sparklinePrices.count > 1
    }

    private var priceChangePercentage: Double {
        enriched.coin.priceChangePercentage24h ?? 0
    }
    
    var isPriceUp: Bool {
        priceChangePercentage >= 0
    }

    var priceChangeIconName: String {
        isPriceUp ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill"
    }
    
    var formattedPrice: String {
        priceFormatter.string(from: NSNumber(value: enriched.coin.currentPrice))
            ?? "$\(enriched.coin.currentPrice)"
    }
    
    var formattedPercentChange: String {
        String(format: "%.2f%%", abs(priceChangePercentage))
    }
    
    // MARK: - Price Formatter
    
    /// Configures a NumberFormatter with smart decimal precision
    /// based on the price magnitude. This ensures readability across
    /// vastly different price ranges (e.g., Bitcoin vs SHIB).
    private var priceFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.locale = Locale(identifier: "en_US")
        
        let decimalConfig = decimalPlaces(for: enriched.coin.currentPrice)
        formatter.minimumFractionDigits = decimalConfig.minimum
        formatter.maximumFractionDigits = decimalConfig.maximum
        
        return formatter
    }
    
    /// Returns appropriate decimal place ranges based on price magnitude.
    /// Larger prices need fewer decimals; smaller prices need more precision.
    private func decimalPlaces(for price: Double) -> (minimum: Int, maximum: Int) {
        switch price {
        case 1_000...:        return (0, 2)   // $73,500
        case 1..<1_000:       return (2, 2)   // $1.50
        case 0.01..<1:        return (4, 4)   // $0.3574
        case 0.0001..<0.01:   return (5, 5)   // $0.00345
        default:              return (6, 8)   // $0.00000023
        }
    }
}
