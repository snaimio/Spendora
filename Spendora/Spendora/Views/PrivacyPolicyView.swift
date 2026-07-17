//
//  PrivacyPolicyView.swift
//  Spendora
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Privacy Policy")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        
                        Text("Last Updated: \(Date().formatted(date: .long, time: .omitted))")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // Sections
                    PrivacyPolicySection(
                        icon: "hand.raised.fill",
                        title: "Data Collection",
                        content: "Spendora does not collect any personal data. All subscription information is stored locally on your device using SwiftData. We do not have access to your subscription data, and we never transmit it to any server."
                    )
                    
                    PrivacyPolicySection(
                        icon: "person.2.slash.fill",
                        title: "No Third-Party Sharing",
                        content: "Since we don't collect any data, we don't share any data with third parties. Your subscription information never leaves your device."
                    )
                    
                    PrivacyPolicySection(
                        icon: "bell.slash.fill",
                        title: "Notifications",
                        content: "If you enable notifications, they are scheduled locally on your device. We do not use push notifications or send any data to external servers for notification purposes."
                    )
                    
                    PrivacyPolicySection(
                        icon: "shield.fill",
                        title: "Data Storage",
                        content: "All your subscription data is stored locally using SwiftData. You have full control over your data and can delete it at any time from the app settings."
                    )
                    
                    PrivacyPolicySection(
                        icon: "icloud.slash.fill",
                        title: "iCloud Sync",
                        content: "If enabled, your data may be synced across your devices using iCloud. Apple handles all data transmission securely. You can disable this at any time."
                    )
                    
                    PrivacyPolicySection(
                        icon: "trash.fill",
                        title: "Your Rights",
                        content: "You have complete control over your data. You can view, edit, or delete all your subscriptions at any time. You can also export your data as CSV, PDF, or JSON backup."
                    )
                    
                    PrivacyPolicySection(
                        icon: "envelope.fill",
                        title: "Contact",
                        content: "If you have any questions about this privacy policy or your data, please contact us at:\n\nsupport@spendora.com"
                    )
                    
                    Divider()
                    
                    // Footer
                    VStack(alignment: .center, spacing: 8) {
                        Image(systemName: "checkmark.shield.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.green, .brandPrimary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Your privacy is our priority")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Spendora respects your privacy and protects your data.")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.brandPrimary)
                }
            }
        }
    }
}

// MARK: - Privacy Policy Section
struct PrivacyPolicySection: View {
    let icon: String
    let title: String
    let content: String
    
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

// MARK: - Preview
#Preview {
    PrivacyPolicyView()
}
