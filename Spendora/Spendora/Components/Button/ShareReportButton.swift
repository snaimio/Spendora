//
//  ShareReportButton.swift
//  Spendora
//

import SwiftUI

struct ShareReportButton: View {
    let action: () -> Void
    
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
