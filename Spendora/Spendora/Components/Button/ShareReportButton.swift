//
//  ShareReportButton.swift
//

import SwiftUI


// MARK: - ShareReportButton

/**
 `ShareReportButton` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for sharereportbutton handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ShareReportButton` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ShareReportButton: View {

    // MARK: - Properties

    let action: () -> Void  // action property
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .font(.headline)
                Text("Share Report")
                    .font(.system(.body, design: .rounded))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "#FF6B6B").opacity(0.2), Color(hex: "#FFE66D").opacity(0.2)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 0.5
                            )
                    )
            )
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    ShareReportButton {
        print("Share tapped")
    }
}
