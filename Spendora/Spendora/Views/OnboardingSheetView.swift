//
//  OnboardingSheetView.swift
//  Spendora
//

import SwiftUI

struct OnboardingSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                        .frame(height: 20)
                    
                    // MARK: - Header Icon
                    Image(systemName: "creditcard.and.123")
                        .font(.system(size: 70))
                        .foregroundStyle(Color.primaryGradient)
                    
                    // MARK: - Title
                    Text("Welcome to Spendora")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Here's what you can do")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    // MARK: - Features Card
                    VStack(alignment: .leading, spacing: 24) {
                        OnboardingSheetFeature(
                            icon: "plus.circle.fill",
                            title: "Track Subscriptions",
                            description: "Add all your subscriptions with name, cost, and billing cycle"
                        )
                        
                        OnboardingSheetFeature(
                            icon: "bell.fill",
                            title: "Smart Reminders",
                            description: "Get notified 3 days before each subscription renews"
                        )
                        
                        OnboardingSheetFeature(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Spending Insights",
                            description: "See charts and AI-powered spending analysis"
                        )
                        
                        OnboardingSheetFeature(
                            icon: "calendar",
                            title: "Calendar View",
                            description: "See all your billing dates in one place"
                        )
                        
                        OnboardingSheetFeature(
                            icon: "square.and.arrow.up",
                            title: "Export Reports",
                            description: "Share your spending as CSV or PDF"
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 30)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Feature Row
struct OnboardingSheetFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.primaryGradient)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingSheetView()
}
