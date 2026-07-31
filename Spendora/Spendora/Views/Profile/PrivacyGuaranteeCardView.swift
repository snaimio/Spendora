/**
 * Main/Core Functions & Purpose:
 * PrivacyGuaranteeCardView renders the 100% On-Device Privacy shield card on the Profile screen.
 */

import SwiftUI

struct PrivacyGuaranteeCardView: View {
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#4ECDC4").opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "lock.shield.fill")
                    .font(.title3)
                    .foregroundColor(Color(hex: "#4ECDC4"))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text("100% On-Device Privacy")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)
                
                Text("Your profile and subscription records stay strictly on your local iPhone. No external cloud servers.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.textSecondary)
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}
