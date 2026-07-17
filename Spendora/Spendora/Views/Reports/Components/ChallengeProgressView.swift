//
//  ChallengeProgressView.swift
//  Spendora
//

import SwiftUI

struct ChallengeProgressView: View {
    let percentage: Int
    
    var body: some View {
        VStack(spacing: 12) {
            Text("🏆 Challenges")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("\(percentage)% Complete")
                .font(.headline)
                .foregroundColor(.secondary)
            
            ProgressView(value: Double(percentage), total: 100)
                .progressViewStyle(.linear)
                .tint(.brandPrimary)
                .frame(height: 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}
