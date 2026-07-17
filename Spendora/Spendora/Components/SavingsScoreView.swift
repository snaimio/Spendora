//
//  SavingsScoreView.swift
//  Spendora
//

import SwiftUI

struct SavingsScoreView: View {
    let subscriptions: [Subscription]

    @State private var showingShareSheet = false
    @State private var shareImage: UIImage?

    var savingsScore: Int {
        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count

        let countScore = max(0, 100 - (count * 5))
        let spendingScore = max(0, 100 - Int(total / 10))

        return min(100, (countScore + spendingScore) / 2)
    }

    var recommendations: [String] {
        var result: [String] = []

        let total = subscriptions.reduce(0) { $0 + $1.monthlyCost }
        let count = subscriptions.count

        if count > 5 {
            result.append("📉 You have \(count) subscriptions. Consider canceling unused ones.")
        }

        if total > 100 {
            result.append("💰 You're spending over $100/month. Review your subscriptions.")
        }

        let trials = subscriptions.filter {
            $0.isTrial && !$0.trialConvertedToPaid
        }

        if !trials.isEmpty {
            result.append("⏰ \(trials.count) trial(s) ending soon. Don't forget to cancel if not needed.")
        }

        if result.isEmpty {
            result.append("🌟 Great job! Your subscription spending is under control.")
        }

        return result
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)

                Text("Savings Score")
                    .font(.headline)

                Spacer()

                Text("\(savingsScore)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(
                        savingsScore > 70 ? .green : .orange
                    )
            }

            Divider()

            ForEach(recommendations, id: \.self) { recommendation in
                Text(recommendation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Button {
                generateShareImage()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Savings Score")

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 5
        )
        .sheet(isPresented: $showingShareSheet) {
            if let image = shareImage {
                ShareSheet(items: [image])
            }
        }
    }

    private func generateShareImage() {
        let renderer = ImageRenderer(
            content: ShareableScoreCard(
                score: savingsScore,
                count: subscriptions.count,
                total: subscriptions.reduce(0) { $0 + $1.monthlyCost }
            )
        )

        if let image = renderer.uiImage {
            shareImage = image
            showingShareSheet = true
        }
    }
}

// MARK: - Shareable Score Card

struct ShareableScoreCard: View {
    let score: Int
    let count: Int
    let total: Double

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("My Savings Score")
                .font(.title2)
                .fontWeight(.bold)

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: CGFloat(score) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round
                        )
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 36, weight: .bold))

                    Text("Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            VStack(spacing: 8) {
                Label(
                    "\(count) subscriptions",
                    systemImage: "number.circle.fill"
                )
                .foregroundColor(.secondary)

                Label(
                    CurrencyManager.shared.format(total) + "/month",
                    systemImage: "dollarsign.circle.fill"
                )
                .foregroundColor(.secondary)
            }

            Text("Generated by Spendora")
                .font(.caption2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(width: 350, height: 400)
        .background(Color(.systemBackground))
    }
}
