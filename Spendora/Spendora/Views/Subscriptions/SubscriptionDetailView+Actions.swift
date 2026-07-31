/**
 * Main/Core Functions & Purpose:
 * Extension for SubscriptionDetailView containing data mutation actions (save, delete, reset values, and get cancellation URL).
 */

import SwiftUI
import SwiftData

extension SubscriptionDetailView {
    
    func getCancellationURL() -> URL? {
        CancellationService.shared.getDirectCancellationURL(
            for: subscription.displayName,
            notes: subscription.notes
        )
    }
    
    func resetValues() {
        name = subscription.name
        cost = String(format: "%.2f", subscription.cost)
        category = subscription.category
        isYearly = subscription.isYearly
        nextBillingDate = subscription.nextBillingDate
        notes = subscription.notes ?? ""
        colorHex = subscription.colorHex ?? "#6C63FF"
        isTrial = subscription.isTrial
        usageRating = subscription.usageRating
        paymentMethod = subscription.paymentMethod ?? "Not Set"
    }
    
    var ratingDescription: String {
        switch usageRating {
        case 5: return "You use this daily - Great value!"
        case 4: return "You use this often - Good value"
        case 3: return "You use this occasionally - Consider if needed"
        case 2: return "You rarely use this - Might be worth cancelling"
        case 1: return "You never use this - Should cancel!"
        default: return ""
        }
    }
    
    func saveChanges() {
        guard isValid else {
            errorMessage = "Please fill in all fields correctly"
            showingError = true
            return
        }
        
        guard let costValue = costValue else {
            errorMessage = "Please enter a valid cost"
            showingError = true
            return
        }
        
        isSaving = true
        
        subscription.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        subscription.cost = costValue
        subscription.category = category
        subscription.isYearly = isYearly
        subscription.nextBillingDate = nextBillingDate
        subscription.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes
        subscription.colorHex = colorHex
        subscription.isTrial = isTrial
        subscription.usageRating = usageRating
        subscription.paymentMethod = paymentMethod
        
        do {
            try modelContext.save()
            isSaving = false
            generator.impactOccurred()
            isEditing = false
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
    
    func deleteSubscription() {
        NotificationService.shared.cancel(for: subscription)
        modelContext.delete(subscription)
        do {
            try modelContext.save()
            generator.impactOccurred()
            dismiss()
        } catch {
            errorMessage = "Failed to delete: \(error.localizedDescription)"
            showingError = true
        }
    }
}
