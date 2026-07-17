//
//  Views/Add/AddSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddSubscriptionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var name = ""
    @State private var cost = ""
    @State private var selectedCategory: String = SubscriptionCategory.other.rawValue
    @State private var isYearly = false
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var selectedColorHex = "#6C63FF"
    @State private var notes = ""
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    @State private var selectedTab = 0
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // Color options (matching Tilla's clean color palette)
    let colorOptions: [(name: String, hex: String)] = [
        ("Purple", "#6C63FF"),
        ("Blue", "#007AFF"),
        ("Red", "#FF3B30"),
        ("Orange", "#FF9500"),
        ("Yellow", "#FFCC00"),
        ("Green", "#34C759"),
        ("Teal", "#5AC8FA"),
        ("Pink", "#FF2D55"),
        ("Gray", "#8E8E93")
    ]
    
    var costValue: Double? { Double(cost) }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (costValue ?? 0) > 0 &&
        nextBillingDate > Date()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Premium Header
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.brandPrimary, .brandSecondary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .padding(.top, 8)
                        
                        Text("Add Subscription")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                        Text("Track your spending with ease")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 12)
                    
                    // Form Cards
                    VStack(spacing: 16) {
                        // Service Name
                        PremiumFormField(
                            icon: "sparkles",
                            title: "Service Name"
                        ) {
                            TextField("e.g. Netflix, Spotify", text: $name)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                                .font(.system(.body, design: .rounded))
                        }
                        
                        // Cost
                        PremiumFormField(
                            icon: "dollarsign.circle.fill",
                            title: isYearly ? "Yearly Cost" : "Monthly Cost"
                        ) {
                            HStack {
                                Text(CurrencyManager.shared.currentCurrency.symbol)
                                    .foregroundColor(.secondary)
                                    .font(.system(.body, design: .rounded))
                                TextField("0.00", text: $cost)
                                    .keyboardType(.decimalPad)
                                    .font(.system(.body, design: .rounded))
                            }
                        }
                        
                        // Category
                        PremiumFormField(
                            icon: "folder.fill",
                            title: "Category"
                        ) {
                            Picker("", selection: $selectedCategory) {
                                ForEach(SubscriptionCategory.allCases, id: \.rawValue) { category in
                                    Label(category.rawValue, systemImage: category.icon)
                                        .tag(category.rawValue)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                        
                        // Billing Cycle
                        PremiumFormField(
                            icon: "repeat.circle.fill",
                            title: "Billing Cycle"
                        ) {
                            Picker("", selection: $isYearly) {
                                Text("Monthly").tag(false)
                                Text("Yearly").tag(true)
                            }
                            .pickerStyle(.segmented)
                            .frame(maxWidth: 200)
                        }
                        
                        // Next Billing Date
                        PremiumFormField(
                            icon: "calendar.circle.fill",
                            title: "Next Billing"
                        ) {
                            DatePicker(
                                "",
                                selection: $nextBillingDate,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .datePickerStyle(.compact)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Color Selection (horizontal scroll like Tilla)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose a Color")
                            .font(.system(.subheadline, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(colorOptions, id: \.hex) { color in
                                    ColorChip(
                                        color: Color(hex: color.hex),
                                        isSelected: selectedColorHex == color.hex,
                                        name: color.name
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedColorHex = color.hex
                                            generator.impactOccurred()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Save Button
                    Button {
                        saveSubscription()
                    } label: {
                        HStack {
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Add Subscription")
                                    .font(.system(.headline, design: .rounded))
                                Image(systemName: "arrow.right.circle.fill")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: isValid ? [.brandPrimary, .brandSecondary] : [.gray, .gray.opacity(0.6)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: isValid ? .brandPrimary.opacity(0.3) : .clear, radius: 12, x: 0, y: 4)
                    }
                    .disabled(!isValid || isSaving)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveSubscription() {
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
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cost: costValue,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            category: selectedCategory,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            isTrial: false,
            trialEndDate: nil,
            expectedPrice: nil,
            priceAlertEnabled: false,
            customCategory: nil,
            paymentMethod: selectedPaymentMethod.rawValue,
            tags: nil,
            colorHex: selectedColorHex,
            usageRating: 0
        )
        
        modelContext.insert(newSubscription)
        
        do {
            try modelContext.save()
            isSaving = false
            NotificationService.shared.schedule(for: newSubscription)
            generator.impactOccurred()
            dismiss()
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            showingError = true
            isSaving = false
        }
    }
}

// MARK: - Premium Form Field
struct PremiumFormField<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.brandPrimary)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                
                content
                    .font(.system(.body, design: .rounded))
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Color Chip
struct ColorChip: View {
    let color: Color
    let isSelected: Bool
    let name: String
    
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: isSelected ? 3 : 0)
                        .shadow(color: .black.opacity(0.15), radius: 4)
                )
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: isSelected ? 1 : 0)
                )
                .scaleEffect(isSelected ? 1.1 : 1.0)
            
            Text(name)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(isSelected ? .primary : .secondary)
        }
    }
}
