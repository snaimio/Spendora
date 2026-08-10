//
//  EmptyStateView.swift
//  Spendora
//

import SwiftUI

// MARK: - EmptyStateView (Apple Native ContentUnavailableView)

struct EmptyStateView: View {

    // MARK: - Properties

    @State private var showingAddSheet = false

    // MARK: - Body

    var body: some View {
        ContentUnavailableView {
            Label("No Subscriptions", systemImage: "creditcard")
        } description: {
            Text("Tap + to add your first subscription and begin tracking your finances.")
        } actions: {
            Button {
                showingAddSheet = true
            } label: {
                Text("Add Subscription")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(SpendoraTheme.accent)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 40)
        .sheet(isPresented: $showingAddSheet) {
            AddSubscriptionView()
        }
    }
}
