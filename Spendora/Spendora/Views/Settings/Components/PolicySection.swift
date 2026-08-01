//
//  PolicySection.swift
//

import SwiftUI


// MARK: - PolicySection

/**
 `PolicySection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for policysection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `PolicySection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct PolicySection: View {

    // MARK: - Properties

    let icon: String  // icon property
    let title: String  // title property
    let content: String  // content property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.brandPrimary.opacity(0.12), .brandSecondary.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.subheadline)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.brandPrimary, .brandSecondary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.system(.body, design: .rounded))
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .padding(.leading, 48)
        }
        .padding(.vertical, 4)
    }
}
