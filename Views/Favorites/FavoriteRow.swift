//
//  FavoriteRow.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 31.05.26.
//

import SwiftUI
import Charts

struct FavoriteRow: View {
    
    private let viewModel: FavoriteRowViewModel
    
    private enum Layout {
        static let iconSize: CGFloat = 36
        static let sparklineWidth: CGFloat = 60
        static let sparklineHeight: CGFloat = 30
        static let priceColumnWidth: CGFloat = 95
        static let columnSpacing: CGFloat = 12
        static let verticalPadding: CGFloat = 6
        static let priceChangeIconSize: CGFloat = 8
    }
    
    init(enriched: EnrichedFavorite) {
        self.viewModel = FavoriteRowViewModel(enriched: enriched)
    }

    var body: some View {
        HStack(spacing: Layout.columnSpacing) {
            coinIcon
            coinInfo
            miniSparkline
            priceSection
        }
        .padding(.vertical, Layout.verticalPadding)
    }
   
    private var coinIcon: some View {
        AsyncImage(url: viewModel.imageURL) { image in
            image.resizable().scaledToFit()
        } placeholder: {
            iconPlaceholder
        }
        .frame(width: Layout.iconSize, height: Layout.iconSize)
    }
    
    private var iconPlaceholder: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .overlay {
                ProgressView()
                    .scaleEffect(0.6)
            }
    }
    
    private var coinInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(viewModel.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Text(viewModel.symbol)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var miniSparkline: some View {
        if viewModel.hasSparklineData {
            sparklineChart
        } else {
            sparklinePlaceholder
        }
    }
    
    private var sparklineChart: some View {
        Chart {
            ForEach(Array(viewModel.sparklinePrices.enumerated()), id: \.offset) { index, price in
                LineMark(
                    x: .value("Time", index),
                    y: .value("Price", price)
                )
                .foregroundStyle(viewModel.isPriceUp ? .green : .red)
                .lineStyle(StrokeStyle(lineWidth: 1.5))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(width: Layout.sparklineWidth, height: Layout.sparklineHeight)
    }
    
    /// Reserves space when no sparkline data is available,
    /// keeping the row layout consistent across all coins.
    private var sparklinePlaceholder: some View {
        Color.clear
            .frame(width: Layout.sparklineWidth, height: Layout.sparklineHeight)
    }
    
    // MARK: - Price Section
    
    private var priceSection: some View {
        VStack(alignment: .trailing, spacing: 2) {
            priceLabel
            priceChangeLabel
        }
        .frame(width: Layout.priceColumnWidth, alignment: .trailing)
    }
    
    private var priceLabel: some View {
        Text(viewModel.formattedPrice)
            .font(.subheadline)
            .fontWeight(.semibold)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .contentTransition(.numericText())
    }
    
    private var priceChangeLabel: some View {
        HStack(spacing: 2) {
            Image(systemName: viewModel.priceChangeIconName)
                .font(.system(size: Layout.priceChangeIconSize))
            
            Text(viewModel.formattedPercentChange)
                .font(.caption2)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .foregroundColor(viewModel.isPriceUp ? .green : .red)
    }
}
