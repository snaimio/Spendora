//
//  EmptyStateView.swift
//

import SwiftUI

// MARK: - EmptyStateView

/**
 `EmptyStateView` renders an engaging empty state with an animated icon and quick-add preset cards.
 */
struct EmptyStateView: View {

    // MARK: - Properties

    @State private var pulse = false
    @State private var showingAddSheet = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#6366F1").opacity(0.15), Color(hex: "#8B5CF6").opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .scaleEffect(pulse ? 1.06 : 0.94)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: 6) {
                Text("No Subscriptions Yet")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Tap the '+' button or choose from popular presets below")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Quick Add Preset Chips Carousel
            VStack(alignment: .leading, spacing: 10) {
                Text("QUICK ADD POPULAR PRESETS")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(1.0)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SubscriptionPreset.all.prefix(12)) { preset in
                            Button {
                                showingAddSheet = true
                            } label: {
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(preset.color.opacity(0.15))
                                            .frame(width: 28, height: 28)
                                        
                                        Image(systemName: preset.systemIcon)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(preset.color)
                                    }
                                    
                                    Text(preset.name)
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                }
                                .padding(.leading, 6)
                                .padding(.trailing, 14)
                                .padding(.vertical, 8)
                                .background(Color.cardBackground)
                                .cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(preset.color.opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .onAppear {
            pulse = true
        }
        .sheet(isPresented: $showingAddSheet) {
            AddSubscriptionView()
        }
    }
}
