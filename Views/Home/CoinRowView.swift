//
//  CoinRowView.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(coin.name).font(.headline)
                Text(coin.symbol.uppercased()).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(coin.currentPrice, specifier: "%.2f")")
                    .font(.subheadline).bold()
                if let change = coin.priceChangePercentage24h {
                    Text("\(change, specifier: "%.2f")%")
                        .font(.caption)
                        .foregroundColor(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
