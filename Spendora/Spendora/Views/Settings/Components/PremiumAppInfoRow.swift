//
//  PremiumAppInfoRow.swift
//

import SwiftUI


// MARK: - PremiumAppInfoRow

/**
 `PremiumAppInfoRow` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for premiumappinforow handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PremiumAppInfoRow` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PremiumAppInfoRow: View {

    // MARK: - Properties


    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                // Background Ambient Glow Ring
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.brandPrimary.opacity(0.3), .brandSecondary.opacity(0.15)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 66, height: 66)
                    .blur(radius: 4)

                Image("SpendoraLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 52, height: 52)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "#C6A473"), Color(hex: "#DFCAA6")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color(hex: "#C6A473").opacity(0.35), radius: 8, x: 0, y: 4)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text("SPENDORA")
                        .font(.system(size: 18, weight: .black, design: .default))
                        .tracking(1.2)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 3) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 9))
                        Text("CAPSTONE")
                            .font(.system(size: 9, weight: .bold, design: .default))
                    }
                    .foregroundColor(Color(hex: "#0E0E10"))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(Color.brandPrimary)
                    .cornerRadius(6)
                }

                Text("Smart Subscription & Expense Intelligence")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text("Version \(getAppVersion())")
                    .font(.system(size: 10, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary.opacity(0.8))
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 8)
    }
    

    /**
     Executes `getAppVersion` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
