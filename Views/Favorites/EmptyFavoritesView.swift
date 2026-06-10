//
//  EmptyFavoritesView.swift
//  CryptoCurrencyTracker
//
//  Created by Sharvani Karrepu on 09.06.26.
//

// EmptyFavoritesView.swift
import SwiftUI

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            starIcon
            messageSection
            instructionCard
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var starIcon: some View {
        ZStack {
            Circle()
                .fill(Color.yellow.opacity(0.1))
                .frame(width: 100, height: 100)
            
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
        }
    }
    
    private var messageSection: some View {
        VStack(spacing: 8) {
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Star your favorite coins to track them here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
    
    private var instructionCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .foregroundColor(.orange)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("How to add favorites")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                Text("Tap any coin → tap the ⭐ icon")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 40)
    }
}
