//
//  CancelSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData

struct CancelSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let subscription: Subscription
    
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
