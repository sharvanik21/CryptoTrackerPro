//
//  DetailViewModel.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class DetailViewModel {
    private(set) var coin: Coin
    private(set) var favoriteErrorMessage: String?
    var isFavorite: Bool = false
    
    private var modelContext: ModelContext?
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    var isPriceUp: Bool {
        (coin.priceChangePercentage24h ?? 0) >= 0
    }
    
    var formattedPrice: String {
        String(format: "$%.2f", coin.currentPrice)
    }
    
    var formattedPriceChange: String {
        guard let price = coin.priceChangePercentage24h else { return "--" }
        let arrow = price >= 0 ? "▲" : "▼"
        return String(format: "%@ %.2f%%", arrow, abs(price))
    }
    
    var formattedMarketCap: String {
        formatLargeNumber(coin.marketCap)
    }
    
    var formattedVolume: String {
        guard let volume = coin.totalVolume else { return "--"}
        return formatLargeNumber(volume)
    }
    
    var formattedHighestPrice24h: String {
        guard let price = coin.highestPrice24h else { return "--"}
        return String(format: "$%.2f", price)
    }
    
    var formattedLowestPrice24h: String {
        guard let price = coin.lowestPrice24h else { return "--"}
        return String(format: "$%.2f", price)
    }
    
    var sparklinePrices: [Double] {
        coin.sparklineIn7d?.price ?? []
    }
    
    var rank: String {
        if let rank = coin.marketCapRank {
            return "#\(rank)"
        }
        return "'Unranked"
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        checkIfFavorite()
    }
    
    private func checkIfFavorite() {
        guard let context = modelContext else { return }
        
        let coinId = coin.id
        let descriptor = FetchDescriptor<FavoriteCoin>(
            predicate: #Predicate { $0.id == coinId }
        )
        
        do {
            let favorites = try context.fetch(descriptor)
            isFavorite = !favorites.isEmpty
        } catch {
            print("Failed to check favorite: \(error)")
        }
    }
    
    func toggleFavorite() {
        guard let context = modelContext else { return }
        
        let coinId = coin.id
        let descriptor = FetchDescriptor<FavoriteCoin>(
            predicate: #Predicate { $0.id == coinId }
        )
        
        do {
            let existing = try context.fetch(descriptor)
            
            if let favorite = existing.first {
                // Remove from favorites
                context.delete(favorite)
                try context.save()
                isFavorite = false
            } else {
                // Add to favorites
                let newFavorite = FavoriteCoin(from: coin)
                context.insert(newFavorite)
                try context.save()
                isFavorite = true
            }
            favoriteErrorMessage = nil
            
        } catch {
            favoriteErrorMessage = "Failed to update favorite. Please try again."
            checkIfFavorite()
        }
    }
    
    func clearFavoriteError() {
        favoriteErrorMessage = nil
    }
    
    private func formatLargeNumber(_ number: Double) -> String {
        let trillion = 1_000_000_000_000.0
        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        
        if number >= trillion {
            return String(format: "$%.2fT", number / trillion)
        } else if number >= billion {
            return String(format: "$%.2fB", number / billion)
        } else if number >= million {
            return String(format: "$%.2fM", number / million)
        } else {
            return String(format: "$%.2f", number)
        }
    }
}
