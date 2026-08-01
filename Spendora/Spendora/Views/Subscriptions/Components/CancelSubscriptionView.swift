//
//  CancelSubscriptionView.swift
//

import SwiftUI
import SwiftData


// MARK: - CancelSubscriptionView

/**
 `CancelSubscriptionView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for cancelsubscriptionview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CancelSubscriptionView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct CancelSubscriptionView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let subscription: Subscription  // subscription property
    
    @State private var cancellationDate = Date()
    @State private var reason = ""
    @State private var selectedReason = ""
    @State private var isSaving = false
    @State private var showAlert = false
    
    let reasons = [
        "Too expensive",
        "Not using enough",
        "Found a better alternative",
        "Trial ended",
        "Budget constraints",
        "Other"
    ]
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        NavigationStack {
            Form {
                Section("Cancellation Details") {
                    DatePicker("Cancellation Date", selection: $cancellationDate, in: ...Date(), displayedComponents: .date)
                    
                    Picker("Reason", selection: $selectedReason) {
                        Text("Select a reason").tag("")
                        ForEach(reasons, id: \.self) { reason in
                            Text(reason).tag(reason)
                        }
                    }
                    
                    if selectedReason == "Other" {
                        TextField("Please specify", text: $reason)
                            .font(.system(.body, design: .rounded))
                    }
                }
                
                Section("Impact") {
                    HStack {
                        Text("Total savings")
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text(CurrencyManager.shared.format(subscription.yearlyCost) + "/year")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Subscription ends")
                            .font(.system(.body, design: .rounded))
                        Spacer()
                        Text(cancellationDate.formatted(date: .abbreviated, time: .omitted))
                            .foregroundColor(.secondary)
                    }
                }
                
                Section {
                    Button {
                        cancelSubscription()
                    } label: {
                        if isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Confirm Cancellation")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isSaving)
                    .listRowBackground(
                        LinearGradient(
                            colors: [Color(hex: "#FF6B6B"), Color(hex: "#FF9A9E")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                }
            }
            .navigationTitle("Cancel Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.brandPrimary)
                }
            }
            .alert("Subscription Cancelled", isPresented: $showAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("\(subscription.displayName) has been cancelled successfully.")
            }
        }
    }
    

    /**
     Executes `cancelSubscription` for component logic.
     
     
     ## Behavior
     1. Validates method arguments and current state.
     2. Executes core computation or state mutation.
     */
    private func cancelSubscription() {
        isSaving = true
        
        subscription.isCancelled = true
        subscription.cancellationDate = cancellationDate
        subscription.cancellationReason = selectedReason == "Other" ? reason : selectedReason
        
        do {
            try modelContext.save()
            isSaving = false
            showAlert = true
        } catch {
            print("Failed to cancel subscription: \(error)")
            isSaving = false
        }
    }
}
