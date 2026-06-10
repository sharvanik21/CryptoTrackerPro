//
//  HomeViewModel.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    private(set) var coins: [Coin] = []
    private(set) var isLoading = false
    var searchText = ""
    var errorMessage: String?
    
    private let coinService: any CoinServiceProtocol
    
    init() {
        self.coinService = CoinService()
    }

    init(coinService: any CoinServiceProtocol) {
        self.coinService = coinService
    }
    
    var filteredCoins: [Coin] {
        guard !searchText.isEmpty else { return coins }
        return coins.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.symbol.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadCoins() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            coins = try await coinService.fetchCoins()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
