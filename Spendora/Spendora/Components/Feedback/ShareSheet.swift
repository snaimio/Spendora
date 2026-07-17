//
//  ShareSheet.swift
//  Spendora
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let excludedActivityTypes: [UIActivity.ActivityType]?
    
    init(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.items = items
        self.excludedActivityTypes = excludedActivityTypes
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        controller.excludedActivityTypes = excludedActivityTypes
        
        // Pre-completion haptic feedback
        controller.completionWithItemsHandler = { _, _, _, _ in
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {
        // No updates needed
    }
}

// MARK: - Premium Share Button
struct PremiumShareButton: View {
    let items: [Any]
    @State private var showingShareSheet = false
    @State private var isPressed = false
    
    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            showingShareSheet = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "square.and.arrow.up")
                    .font(.headline)
                Text("Share")
                    .font(.system(.headline, design: .rounded))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [.brandPrimary, .brandSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: .brandPrimary.opacity(0.3), radius: 10, x: 0, y: 4)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0.01) { pressing in
            isPressed = pressing
        } perform: { }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: items)
        }
    }
}
