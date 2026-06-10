//
//  FavoritesViewModel.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 09.06.26.
//

import Foundation
import Observation

@Observable
@MainActor
final class FavoritesViewModel {
    
    private(set) var favoriteCoins: [FavoriteCoinDetails] = []
    private(set) var isLoading = false
    var errorMessage: String?
    
    private let coinService: CoinServiceProtocol
    
    var favoritesCountText: String {
        let count = favoriteCoins.count
        return "\(count) \(count == 1 ? "coin" : "coins")"
    }
    
    var hasFavorites: Bool {
        !favoriteCoins.isEmpty
    }
    
    init() {
        self.coinService = CoinService()
    }

    init(coinService: any CoinServiceProtocol) {
        self.coinService = coinService
    }
    
    /// Fetches fresh market data and merges it with saved favorites.
    func loadFavorites(_ favorites: [FavoriteCoin]) async {
        guard !favorites.isEmpty else {
            favoriteCoins = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let allCoins = try await coinService.fetchCoins()
            favoriteCoins = mergeData(favorites: favorites, with: allCoins)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Combines persistent favorite records with current market data.
    private func mergeData(
        favorites: [FavoriteCoin],
        with coins: [Coin]
    ) -> [FavoriteCoinDetails] {
        favorites.compactMap { favorite in
            guard let matchingCoin = coins.first(where: { $0.id == favorite.id }) else {
                return nil
            }
            return FavoriteCoinDetails(favorite: favorite, coin: matchingCoin)
        }
    }
}
