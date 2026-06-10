//
//  Detail.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

import SwiftUI
import SwiftData

struct CoinDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DetailViewModel
    
    private var favoriteErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.favoriteErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.clearFavoriteError()
                }
            }
        )
    }
    
    init(coin: Coin) {
        _viewModel = State(initialValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                priceSection
                
                if !viewModel.sparklinePrices.isEmpty {
                    PriceChartView(
                        prices: viewModel.sparklinePrices,
                        isPriceUp: viewModel.isPriceUp
                    )
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics")
                        .font(.headline)
                        .padding(.horizontal)
                    statisticsGrid
                }
            }
            .padding(.vertical)
        }
        .animation(.easeInOut, value: viewModel.sparklinePrices)
        .navigationTitle(viewModel.coin.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        viewModel.toggleFavorite()
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .scaleEffect(viewModel.isFavorite ? 1.2 : 1.0)
                }
            }
        }
        .alert("Favorites Error", isPresented: favoriteErrorBinding) {
            Button("OK") {
                viewModel.clearFavoriteError()
            }
        } message: {
            Text(viewModel.favoriteErrorMessage ?? "")
        }
        .onAppear{
            viewModel.setModelContext(modelContext)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: viewModel.coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            
            Text(viewModel.coin.symbol.uppercased())
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Rank \(viewModel.rank)")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(8)
        }
    }
    
    // MARK: - Price
    
    private var priceSection: some View {
        VStack(spacing: 8) {
            Text(viewModel.formattedPrice)
                .font(.system(size: 40, weight: .bold))
            
            Text(viewModel.formattedPriceChange)
                .font(.headline)
                .foregroundColor(viewModel.isPriceUp ? .green : .red)
        }
    }
    
    // MARK: - Statistics Grid
    
    private var statisticsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatisticsCard(
                title: "Market Cap",
                value: viewModel.formattedMarketCap,
                icon: "chart.pie.fill"
            )
            StatisticsCard(
                title: "24h Volume",
                value: viewModel.formattedVolume,
                icon: "chart.bar.fill"
            )
            StatisticsCard(
                title: "24h High",
                value: viewModel.formattedHighestPrice24h,
                icon: "arrow.up.circle.fill"
            )
            StatisticsCard(
                title: "24h Low",
                value: viewModel.formattedLowestPrice24h,
                icon: "arrow.down.circle.fill"
            )
        }
        .padding(.horizontal)
    }
}
