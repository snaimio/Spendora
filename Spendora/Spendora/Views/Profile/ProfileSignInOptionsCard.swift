/**
 * Main/Core Functions & Purpose:
 * ProfileSignInOptionsCard subview component displaying Apple, Google, and Email authentication action buttons for guest users.
 */

import SwiftUI

struct ProfileSignInOptionsCard: View {
    let onApple: () -> Void
    let onGoogle: () -> Void
    let onEmail: () -> Void
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Authentication Options")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 4)
            
            // Apple Sign-In Button
            Button {
                generator.impactOccurred()
                onApple()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "applelogo")
                        .font(.title3)
                    Text("Sign in with Apple")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.primary)
                .cornerRadius(14)
            }
            
            // Google Sign-In Button
            Button {
                generator.impactOccurred()
                onGoogle()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "g.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color(hex: "#4285F4"))
                    Text("Continue with Google")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.cardBackground)
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
            }
            
            // Email Sign-In Button
            Button {
                generator.impactOccurred()
                onEmail()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "envelope.fill")
                        .font(.subheadline)
                        .foregroundColor(.brandPrimary)
                    Text("Sign in with Email")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.brandPrimary)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.brandPrimary.opacity(0.1))
                .cornerRadius(14)
            }
        }
    }
}
