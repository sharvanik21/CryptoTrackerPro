//
//  PriceChartViewModel.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 31.05.26.
//

// PriceChartViewModel.swift
import SwiftUI
import Charts

struct PriceChartViewModel {
    
    private enum Constants {
        static let stablePriceThreshold = 0.001
        static let minimumDataPoints = 2
        static let flatPricePaddingRatio = 0.05
    }
    
    let prices: [Double]
    let isPriceUp: Bool
    let yAxisLayout: ChartYAxisLayout
    
    init(prices: [Double], isPriceUp: Bool) {
        self.prices = prices
        self.isPriceUp = isPriceUp
        self.yAxisLayout = Self.calculateYAxisLayout(from: prices)
    }
    
    /// Determines which type of chart to render based on data characteristics.
    var chartState: ChartState {
        if prices.isEmpty {
            return .noData
        }
        
        if prices.count < Constants.minimumDataPoints {
            return .insufficientData
        }
        
        if isPriceStable {
            return .stable(price: prices.first ?? 0)
        }
        
        return .normal
    }
    
    /// Returns true when price variation is negligible (e.g., stablecoins).
    private var isPriceStable: Bool {
        guard let minPrice = prices.min(),
              let maxPrice = prices.max(),
              minPrice > 0 else { return false }
        
        let variation = (maxPrice - minPrice) / minPrice
        return variation < Constants.stablePriceThreshold
    }
    
    var lineColor: Color {
        isPriceUp ? .green : .red
    }
    
    var stableColor: Color {
        .blue
    }
    
    var chartData: [PricePoint] {
        prices.enumerated().map { index, price in
            PricePoint(time: index, price: price)
        }
    }
    
    var areaGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: lineColor.opacity(0.40), location: 0.0),
                .init(color: lineColor.opacity(0.25), location: 0.4),
                .init(color: lineColor.opacity(0.10), location: 0.8),
                .init(color: lineColor.opacity(0.0),  location: 1.0)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: - Stable Price Helpers
    
    /// Y-axis domain for stable price visualization (centered line).
    var stablePriceDomain: ClosedRange<Double> {
        guard let price = prices.first else { return 0...1 }
        let padding = max(abs(price) * Constants.flatPricePaddingRatio, 0.0001)
        return (price - padding)...(price + padding)
    }
    
    func formatPriceLabel(_ price: Double) -> String {
        if abs(price) >= 1_000_000 {
            return formatAsMillions(price)
        }
        if abs(price) >= 1_000 {
            return formatAsThousands(price)
        }
        return String(format: "$%.\(yAxisLayout.decimalPlaces)f", price)
    }
    
    private func formatAsMillions(_ price: Double) -> String {
        let decimals = yAxisLayout.tickInterval >= 100_000 ? 1 : 2
        return String(format: "$%.\(decimals)fM", price / 1_000_000)
    }
    
    private func formatAsThousands(_ price: Double) -> String {
        let decimals: Int
        switch yAxisLayout.tickInterval {
        case 1000...:      decimals = 0
        case 100..<1000:   decimals = 1
        default:           decimals = 2
        }
        return String(format: "$%.\(decimals)fK", price / 1000)
    }
}

// MARK: - Chart State

extension PriceChartViewModel {
    
    /// Represents the visual state of the price chart based on data quality.
    enum ChartState {
        case noData
        case insufficientData
        case stable(price: Double)
        case normal
    }
}

// MARK: - Y-Axis Layout Calculation

extension PriceChartViewModel {
    
    struct ChartYAxisLayout {
        let tickValues: [Double]
        let tickInterval: Double
        let axisLowerBound: Double
        let axisUpperBound: Double
        let decimalPlaces: Int
        
        static let empty = ChartYAxisLayout(
            tickValues: [],
            tickInterval: 1,
            axisLowerBound: 0,
            axisUpperBound: 1,
            decimalPlaces: 2
        )
    }
    
    private enum IntervalRoundingMode {
        case nearest
        case ceiling
    }
    
    private static func calculateYAxisLayout(from prices: [Double]) -> ChartYAxisLayout {
        guard let minPrice = prices.min(),
              let maxPrice = prices.max(),
              minPrice < maxPrice else {
            return .empty
        }
        
        let priceRange = maxPrice - minPrice
        let targetTickCount = 4
        let rawTickInterval = priceRange / Double(targetTickCount - 1)
        let tickInterval = roundToReadableInterval(rawTickInterval, mode: .nearest)
        
        let lowerTickBound = (minPrice / tickInterval).rounded(.down) * tickInterval
        let upperTickBound = (maxPrice / tickInterval).rounded(.up) * tickInterval
        
        let tickValues = generateTickValues(
            from: lowerTickBound,
            to: upperTickBound,
            interval: tickInterval
        )
        
        let decimalPlaces = calculateDecimalPlaces(forInterval: tickInterval)
        
        return ChartYAxisLayout(
            tickValues: tickValues,
            tickInterval: tickInterval,
            axisLowerBound: lowerTickBound,
            axisUpperBound: upperTickBound,
            decimalPlaces: decimalPlaces
        )
    }
    
    private static func roundToReadableInterval(
        _ value: Double,
        mode: IntervalRoundingMode
    ) -> Double {
        guard value > 0 else { return 1 }
        
        let magnitude = pow(10, floor(log10(value)))
        let normalizedValue = value / magnitude
        
        let readableMultiplier: Double
        switch mode {
        case .nearest:
            if normalizedValue < 1.5 { readableMultiplier = 1 }
            else if normalizedValue < 3 { readableMultiplier = 2 }
            else if normalizedValue < 7 { readableMultiplier = 5 }
            else { readableMultiplier = 10 }
            
        case .ceiling:
            if normalizedValue <= 1 { readableMultiplier = 1 }
            else if normalizedValue <= 2 { readableMultiplier = 2 }
            else if normalizedValue <= 5 { readableMultiplier = 5 }
            else { readableMultiplier = 10 }
        }
        
        return readableMultiplier * magnitude
    }
    
    private static func generateTickValues(
        from lowerBound: Double,
        to upperBound: Double,
        interval: Double
    ) -> [Double] {
        var values: [Double] = []
        var currentValue = lowerBound
        let epsilon = interval * 0.0001
        
        while currentValue <= upperBound + epsilon {
            values.append(currentValue)
            currentValue += interval
        }
        return values
    }
    
    private static func calculateDecimalPlaces(forInterval interval: Double) -> Int {
        guard interval > 0 else { return 2 }
        return max(0, Int(-floor(log10(interval))))
    }
}

// MARK: - Supporting Types

struct PricePoint: Identifiable {
    let id = UUID()
    let time: Int
    let price: Double
}
