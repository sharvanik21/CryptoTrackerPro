//
//  FavoritesViewswift.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 31.05.26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteCoin.addedAt, order: .reverse)
    private var favorites: [FavoriteCoin]
    
    @State private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Favorites")
                .task {
                    await viewModel.loadFavorites(favorites)
                }
                .onChange(of: favorites) { _, newFavorites in
                    Task {
                        await viewModel.loadFavorites(newFavorites)
                    }
                }
                .refreshable {
                    await viewModel.loadFavorites(favorites)
                }
                .navigationDestination(for: Coin.self) { coin in
                    CoinDetailView(coin: coin)
                }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if favorites.isEmpty {
            EmptyFavoritesView()
        } else if viewModel.isLoading && viewModel.favoriteCoins.isEmpty {
            loadingView
        } else if let error = viewModel.errorMessage,
                  viewModel.favoriteCoins.isEmpty {
            errorView(message: error)
        } else {
            favoritesList
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading prices...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("Couldn't Load Prices")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                Task { await viewModel.loadFavorites(favorites) }
            } label: {
                Label("Try Again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        List {
            ForEach(viewModel.favoriteCoins) { favorite in
                NavigationLink(value: favorite.coin) {
                    FavoriteRow(favorite: favorite)
                }
            }
            .onDelete(perform: deleteFavorites)
        }
        .listStyle(.insetGrouped)
    }
    
    private func lastUpdatedFooter(_ date: Date) -> some View {
        HStack {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.caption2)
            Text("Updated \(date, style: .relative) ago")
                .font(.caption2)
            Spacer()
        }
        .foregroundColor(.secondary)
        .listRowBackground(Color.clear)
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = viewModel.favoriteCoins[index]
            if let favoriteToDelete = favorites.first(where: { $0.id == favorite.id }) {
                modelContext.delete(favoriteToDelete)
            }
        }
        try? modelContext.save()
    }
}
