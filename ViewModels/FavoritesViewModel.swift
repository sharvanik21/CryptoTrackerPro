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
    
    private(set) var enrichedFavorites: [EnrichedFavorite] = []
    private(set) var isLoading = false
    private(set) var lastUpdated: Date?
    var errorMessage: String?
    
    private let coinService: CoinServiceProtocol
    private var liveUpdateTask: Task<Void, Never>?
    
    private enum Constants {
        static let liveUpdateInterval: Duration = .seconds(30)
    }
    
    init() {
        self.coinService = CoinService()
    }

    init(coinService: any CoinServiceProtocol) {
        self.coinService = coinService
    }
    
    // MARK: - Data Loading
    
    /// Fetches fresh market data and merges it with saved favorites.
    func loadFavorites(_ favorites: [FavoriteCoin]) async {
        guard !favorites.isEmpty else {
            enrichedFavorites = []
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let allCoins = try await coinService.fetchCoins()
            enrichedFavorites = mergeData(favorites: favorites, with: allCoins)
            lastUpdated = Date()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Combines persistent favorite records with current market data.
    private func mergeData(
        favorites: [FavoriteCoin],
        with coins: [Coin]
    ) -> [EnrichedFavorite] {
        favorites.compactMap { favorite in
            guard let matchingCoin = coins.first(where: { $0.id == favorite.id }) else {
                return nil
            }
            return EnrichedFavorite(favorite: favorite, coin: matchingCoin)
        }
    }
    
    // MARK: - Live Updates
    
    func startLiveUpdates(for favorites: [FavoriteCoin]) {
        liveUpdateTask?.cancel()
        liveUpdateTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: Constants.liveUpdateInterval)
                guard !Task.isCancelled else { break }
                await loadFavorites(favorites)
            }
        }
    }
    
    func stopLiveUpdates() {
        liveUpdateTask?.cancel()
        liveUpdateTask = nil
    }
    
    // MARK: - Computed Properties
    
    var favoritesCountText: String {
        let count = enrichedFavorites.count
        return "\(count) \(count == 1 ? "coin" : "coins")"
    }
    
    var hasFavorites: Bool {
        !enrichedFavorites.isEmpty
    }
}
