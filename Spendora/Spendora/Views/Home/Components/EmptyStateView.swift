/**
 * Main/Core Functions & Purpose:
 * EmptyStateView component displaying friendly animated pulsing state when no subscriptions match search or exist in local DB.
 */

import SwiftUI

struct EmptyStateView: View {
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B").opacity(0.1), Color(hex: "#FFE66D").opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(pulse ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: pulse)
                
                Image(systemName: "creditcard.and.123")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.brandPrimary)
            }
            
            VStack(spacing: 8) {
                Text("No Subscriptions Yet")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Start tracking your subscriptions\nin just a few taps")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .onAppear {
            pulse = true
        }
    }
}
