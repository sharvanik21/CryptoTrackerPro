//
//  ErrorView.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani, Karrepu on 30.05.26.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(message).multilineTextAlignment(.center)
            Button("Retry", action: retry).buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
