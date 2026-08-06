//
//  EmptyStateView.swift
//

import SwiftUI

// MARK: - EmptyStateView

/**
 `EmptyStateView` renders an industry-standard empty state featuring a vector smartphone + credit card illustration,
 friendly instruction copy, and quick-add preset cards inspired by top subscription manager apps.
 */
struct EmptyStateView: View {

    // MARK: - Properties

    @State private var pulse = false
    @State private var showingAddSheet = false

    // MARK: - Body

    var body: some View {
        VStack(spacing: 24) {
            // Vector Graphic (Smartphone & Credit Card) inspired by SubX
            ZStack {
                // Background Soft Aura Glow
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#6366F1").opacity(0.12), Color(hex: "#0EA5E9").opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .scaleEffect(pulse ? 1.08 : 0.94)
                    .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: pulse)
                
                // Smartphone Body
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(LinearGradient(colors: [Color(hex: "#6366F1"), Color(hex: "#0EA5E9")], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.cardBackground)
                    )
                    .frame(width: 80, height: 110)
                    .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 5)
                    .overlay(
                        VStack(spacing: 6) {
                            Capsule()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(width: 24, height: 4)
                            
                            Image("AppLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                                .opacity(0.85)
                            
                            Spacer()
                        }
                        .padding(.top, 8)
                    )
                    .offset(x: -16, y: -8)
                
                // Credit Card Graphic Overlay
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#0EA5E9"), Color(hex: "#6366F1")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 76, height: 48)
                    .shadow(color: Color(hex: "#0EA5E9").opacity(0.35), radius: 8, x: 2, y: 4)
                    .overlay(
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(hex: "#F59E0B"))
                                    .frame(width: 10, height: 8)
                                Spacer()
                                Circle()
                                    .fill(Color.white.opacity(0.6))
                                    .frame(width: 8, height: 8)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 3) {
                                Circle().fill(Color.white.opacity(0.8)).frame(width: 3, height: 3)
                                Circle().fill(Color.white.opacity(0.8)).frame(width: 3, height: 3)
                                Circle().fill(Color.white.opacity(0.8)).frame(width: 3, height: 3)
                                Circle().fill(Color.white.opacity(0.8)).frame(width: 3, height: 3)
                            }
                        }
                        .padding(6)
                    )
                    .offset(x: 18, y: 16)
            }
            .frame(height: 140)
            
            VStack(spacing: 6) {
                Text("No Subscriptions")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Add a subscription by tapping the '+' button\nor selecting a popular preset below")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            
            // Quick Add Preset Chips Carousel
            VStack(alignment: .leading, spacing: 10) {
                Text("POPULAR PRESETS")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(1.2)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SubscriptionPreset.all.prefix(15)) { preset in
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
            .padding(.top, 4)
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
