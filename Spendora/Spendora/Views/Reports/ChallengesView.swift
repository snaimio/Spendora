//
//  ChallengesView.swift
//  Spendora
//

import SwiftUI

struct ChallengesView: View {
    let subscriptions: [Subscription]
    @State private var completedChallenges: Set<String> = []
    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?
    
    var challenges: [Challenge] {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        let yearlyCount = subscriptions.filter { $0.isYearly }.count
        let trialCount = subscriptions.filter { $0.isTrial && !$0.trialConvertedToPaid }.count
        
        return [
            Challenge(
                id: "first",
                title: "First Subscription",
                description: "Add your first subscription",
                icon: "star.fill",
                isCompleted: count >= 1,
                color: .yellow
            ),
            Challenge(
                id: "five",
                title: "Subscription Collector",
                description: "Track 5 subscriptions",
                icon: "number.circle.fill",
                isCompleted: count >= 5,
                color: .blue
            ),
            Challenge(
                id: "ten",
                title: "Subscription Master",
                description: "Track 10 subscriptions",
                icon: "trophy.fill",
                isCompleted: count >= 10,
                color: .orange
            ),
            Challenge(
                id: "budget",
                title: "Budget Conscious",
                description: "Keep monthly spending under $50",
                icon: "dollarsign.circle.fill",
                isCompleted: total <= 50 && count > 0,
                color: .green
            ),
            Challenge(
                id: "yearly",
                title: "Yearly Planner",
                description: "Have 3 yearly subscriptions",
                icon: "calendar",
                isCompleted: yearlyCount >= 3,
                color: .purple
            ),
            Challenge(
                id: "trial",
                title: "Trial Tracker",
                description: "Track 2 active trials",
                icon: "clock.fill",
                isCompleted: trialCount >= 2,
                color: .orange
            ),
            Challenge(
                id: "saver",
                title: "Saver",
                description: "Have a savings score of 80+",
                icon: "star.circle.fill",
                isCompleted: calculateSavingsScore() >= 80 && count > 0,
                color: .yellow
            )
        ]
    }
    
    var completionPercentage: Int {
        let completed = challenges.filter { $0.isCompleted }.count
        return challenges.isEmpty ? 0 : (completed * 100) / challenges.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Progress Header
                    ChallengeProgressView(percentage: completionPercentage)
                    
                    // Challenges Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(challenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                    
                    // Share Progress Button
                    if challenges.filter({ $0.isCompleted }).count > 0 {
                        ShareReportButton {
                            generateShareImage()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Challenges")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingShareSheet) {
                if let image = shareImage {
                    ShareSheet(items: [image])
                }
            }
        }
    }
    
    private func calculateSavingsScore() -> Int {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count
        let countScore = max(0, 100 - (count * 5))
        let spendingScore = max(0, 100 - Int(total / 10))
        return min(100, (countScore + spendingScore) / 2)
    }
    
    private func generateShareImage() {
        let renderer = ImageRenderer(content: ShareableChallenges(
            percentage: completionPercentage,
            challenges: challenges
        ))
        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Challenge Model
struct Challenge: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let isCompleted: Bool
    let color: Color
}

// MARK: - Challenge Card
struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(challenge.isCompleted ? challenge.color : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: challenge.icon)
                    .font(.title2)
                    .foregroundColor(challenge.isCompleted ? .white : .gray)
            }
            
            Text(challenge.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(challenge.description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if challenge.isCompleted {
                Label("Done", systemImage: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(height: 140)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5)
        .opacity(challenge.isCompleted ? 1 : 0.6)
    }
}
