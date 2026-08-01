//
//  AboutCapstoneView.swift
//

/**
 * Main/Core Functions & Purpose:
 * AboutCapstoneView screen documenting project metadata, developer contact details (support@spendora.app),
 * triOS College 2026 Mobile Application Development Capstone goals, architecture overview, and privacy guarantees.
 */

import SwiftUI


// MARK: - AboutCapstoneView

/**
 `AboutCapstoneView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for aboutcapstoneview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `AboutCapstoneView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct AboutCapstoneView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @State private var showingOnboarding = false
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Banner
                VStack(spacing: 14) {
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: [.brandPrimary.opacity(0.6), .brandSecondary.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.brandPrimary.opacity(0.3), radius: 15, x: 0, y: 8)
                    
                    VStack(spacing: 4) {
                        Text("Spendora")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("Smart Subscription & Expense Intelligence")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 6) {
                            Text("Version 1.0 (Build 1)")
                                .font(.system(.caption, design: .rounded))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.secondary.opacity(0.12))
                                .cornerRadius(12)
                            
                            HStack(spacing: 3) {
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption2)
                                Text("CAPSTONE READY")
                                    .font(.system(.caption2, design: .rounded))
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                LinearGradient(
                                    colors: [.brandPrimary, .brandSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.top, 16)
                
                // Capstone Information Card
                VStack(alignment: .leading, spacing: 14) {
                    Label("Capstone Project Info", systemImage: "graduationcap.fill")
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.brandPrimary)
                    
                    Divider()
                    
                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 10) {
                        GridRow {
                            Text("Project")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("Spendora Mobile App")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        
                        GridRow {
                            Text("Developer")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("Sheikh Naim")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        
                        GridRow {
                            Text("Contact")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("support@spendora.app")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        
                        GridRow {
                            Text("Framework")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("SwiftUI, SwiftData, Swift Charts")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                        
                        GridRow {
                            Text("Platform")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundColor(.secondary)
                            Text("iOS 17+ (iPhone & iPad)")
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(18)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(20)
                .padding(.horizontal)
                
                // Architectural Highlights Card
                AboutArchitecturalHighlightsCard()
                
                // Footer
                Text("Designed & Built for iOS 2026 Mobile Capstone Project")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 24)
            }
        }
        .navigationTitle("About Spendora")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
                .font(.system(.body, design: .rounded))
                .fontWeight(.bold)
            }
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            PremiumOnboardingView(hasCompletedOnboarding: .constant(true))
        }
    }
}


// MARK: - Preview

/// Xcode Canvas Preview Provider.
#Preview {
    NavigationStack {
        AboutCapstoneView()
    }
}
