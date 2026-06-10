//
//  Home.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 30.05.26.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.coins.isEmpty {
                    ProgressView("Loading coins...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadCoins() }
                    }
                } else {
                    coinList
                }
            }
            .navigationTitle("Crypto Tracker")
            .searchable(text: $viewModel.searchText, prompt: "Search coins")
            .task {
                if viewModel.coins.isEmpty {
                    await viewModel.loadCoins()
                }
            }
            .refreshable { await viewModel.loadCoins() }
        }
    }
    
    private var coinList: some View {
        List(viewModel.filteredCoins) { coin in
            NavigationLink(value: coin) {
                CoinRowView(coin: coin)
            }
        }
        .navigationDestination(for: Coin.self) { coin in
            CoinDetailView(coin: coin)
        }
    }
}

