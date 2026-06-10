//
//  PriceChartView.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

// PriceChartView.swift
import SwiftUI
import Charts

struct PriceChartView: View {
    private let viewModel: PriceChartViewModel
    
    init(prices: [Double], isPriceUp: Bool) {
        self.viewModel = PriceChartViewModel(
            prices: prices,
            isPriceUp: isPriceUp
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            chartTitle
            chartContent
        }
    }
    
    private var chartTitle: some View {
        Text("Price Chart (7 Days)")
            .font(.headline)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var chartContent: some View {
        switch viewModel.chartState {
        case .noData:
            noDataPlaceholder
        case .insufficientData:
            insufficientDataPlaceholder
        case .stable(let price):
            stablePriceChart(price: price)
        case .normal:
            normalPriceChart
        }
    }
    
    private var noDataPlaceholder: some View {
        EmptyStateView(
            icon: "chart.xyaxis.line",
            title: "No Price Data",
            message: "Price history is not available for this coin"
        )
    }
    
    private var insufficientDataPlaceholder: some View {
        EmptyStateView(
            icon: "chart.line.downtrend.xyaxis",
            title: "Not Enough Data",
            message: "We need more data points to display a chart"
        )
    }
    
    // MARK: - Stable Price State
    
    private func stablePriceChart(price: Double) -> some View {
        VStack(spacing: 16) {
            stablePriceBadge
            stablePriceVisualization(price: price)
            stablePriceCaption
        }
        .padding(.horizontal)
    }
    
    private var stablePriceBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "equal.circle.fill")
            Text("Stable Price")
                .fontWeight(.medium)
        }
        .font(.subheadline)
        .foregroundColor(viewModel.stableColor)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(viewModel.stableColor.opacity(0.1))
        .clipShape(Capsule())
    }
    
    private func stablePriceVisualization(price: Double) -> some View {
        Chart {
            RuleMark(y: .value("Stable Price", price))
                .foregroundStyle(viewModel.stableColor)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [6, 4]))
                .annotation(position: .top, alignment: .center, spacing: 8) {
                    priceAnnotation(price: price)
                }
        }
        .chartYScale(domain: viewModel.stablePriceDomain)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 140)
    }
    
    private func priceAnnotation(price: Double) -> some View {
        Text(viewModel.formatPriceLabel(price))
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(viewModel.stableColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(viewModel.stableColor.opacity(0.1))
            .clipShape(Capsule())
    }
    
    private var stablePriceCaption: some View {
        Text("Price has remained stable over the last 7 days")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
    
    
    private var normalPriceChart: some View {
        Chart(viewModel.chartData) { point in
            priceArea(for: point)
            priceLine(for: point)
        }
        .chartYScale(domain: viewModel.yAxisLayout.axisLowerBound...viewModel.yAxisLayout.axisUpperBound)
        .chartXAxis(.hidden)
        .chartYAxis { yAxisContent }
        .frame(height: 200)
        .padding(.horizontal)
    }
    
    private func priceLine(for point: PricePoint) -> some ChartContent {
        LineMark(
            x: .value("Time", point.time),
            y: .value("Price", point.price)
        )
        .foregroundStyle(viewModel.lineColor)
        .lineStyle(StrokeStyle(lineWidth: 2))
        .interpolationMethod(.catmullRom)
    }
    
    private func priceArea(for point: PricePoint) -> some ChartContent {
        AreaMark(
            x: .value("Time", point.time),
            yStart: .value("Lower Bound", viewModel.yAxisLayout.axisLowerBound),
            yEnd: .value("Price", point.price)
        )
        .foregroundStyle(viewModel.areaGradient)
        .interpolationMethod(.catmullRom)
    }
    
    private var yAxisContent: some AxisContent {
        AxisMarks(position: .leading, values: viewModel.yAxisLayout.tickValues) { value in
            AxisGridLine()
                .foregroundStyle(Color.gray.opacity(0.2))
            AxisValueLabel {
                if let price = value.as(Double.self) {
                    Text(viewModel.formatPriceLabel(price))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

private struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
