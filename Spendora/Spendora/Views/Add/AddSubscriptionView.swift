//
//  AddSubscriptionView.swift
//  Spendora
//

import SwiftUI
import SwiftData

// MARK: - AddSubscriptionView

/**
 `AddSubscriptionView` allows users to create new subscription records with Spendora Teal branding and presets.
 */
struct AddSubscriptionView: View {

    // MARK: - Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    @State private var name = ""
    @State private var cost = ""
    @State private var selectedCategory: String = SubscriptionCategory.other.rawValue
    @State private var isYearly = false
    @State private var isOneTime = false
    @State private var linkURL = ""
    @State private var isUserEditedLink = false
    @State private var nextBillingDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    @State private var selectedColorHex = "#00D4AA"
    @State private var notes = ""
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var reminderDaysBefore = 3
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isSaving = false
    @State private var showingQuickAddSheet = false
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let colorOptions = AddSubscriptionColorOptions.all
    
    // MARK: - Computed Properties
    var costValue: Double? {
        let sanitized = cost.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(sanitized)
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (costValue ?? 0) > 0
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                SpendoraBrandBackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        AddSubscriptionHeaderView()
                        
                        // Popular Providers Preset Selector
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Popular Providers")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.textSecondary)
                                Spacer()
                                Button {
                                    generator.impactOccurred()
                                    showingQuickAddSheet = true
                                } label: {
                                    Text("See All")
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(hex: "#00D4AA"))
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(SubscriptionPreset.all.prefix(15)) { preset in
                                        Button {
                                            generator.impactOccurred()
                                            applyPreset(preset)
                                        } label: {
                                            HStack(spacing: 8) {
                                                ZStack {
                                                    Circle()
                                                        .fill(preset.color.opacity(0.16))
                                                        .frame(width: 28, height: 28)
                                                    
                                                    Image(systemName: preset.systemIcon)
                                                        .foregroundColor(preset.color)
                                                        .font(.system(size: 13, weight: .semibold))
                                                }
                                                
                                                Text(preset.name)
                                                    .font(.system(.subheadline, design: .rounded))
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.textPrimary)
                                            }
                                            .padding(.leading, 6)
                                            .padding(.trailing, 14)
                                            .padding(.vertical, 8)
                                            .background(Color.cardBackground)
                                            .cornerRadius(14)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(name == preset.name ? Color(hex: "#00D4AA") : Color.secondary.opacity(0.12), lineWidth: name == preset.name ? 2 : 1)
                                            )
                                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        AddSubscriptionFormView(
                            name: $name,
                            cost: $cost,
                            selectedCategory: $selectedCategory,
                            isYearly: $isYearly,
                            isOneTime: $isOneTime,
                            linkURL: $linkURL,
                            isUserEditedLink: $isUserEditedLink,
                            nextBillingDate: $nextBillingDate,
                            selectedPaymentMethod: $selectedPaymentMethod,
                            reminderDaysBefore: $reminderDaysBefore
                        )
                        .onChange(of: name) { _, newName in
                            autoGenerateLinkIfNeeded(for: newName)
                        }
                        
                        AddColorSelectionView(
                            colorOptions: colorOptions,
                            selectedColorHex: $selectedColorHex,
                            generator: generator
                        )
                        
                        AddNotesView(notes: $notes)
                        
                        AddSubscriptionSaveButton(
                            isValid: isValid,
                            isSaving: isSaving,
                            action: saveSubscription
                        )
                    }
                    .padding(.bottom, 36)
                }
            }
            .sheet(isPresented: $showingQuickAddSheet) {
                QuickAddView { preset in
                    applyPreset(preset)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color(hex: "#FF6B6B"))
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(hex: "#00D4AA"))
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Auto Generate URL Helper
    private func autoGenerateLinkIfNeeded(for serviceName: String) {
        guard !isUserEditedLink else { return }
        let trimmed = serviceName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            linkURL = ""
            return
        }
        
        // 1. Check matching preset in 100 Popular Presets library
        if let matchingPreset = SubscriptionPreset.all.first(where: {
            $0.name.localizedCaseInsensitiveContains(trimmed) || trimmed.localizedCaseInsensitiveContains($0.name)
        }), let presetURL = matchingPreset.cancellationUrl, !presetURL.isEmpty {
            linkURL = presetURL
            return
        }
        
        // 2. Fallback to CancellationService direct lookup
        if let detectedURL = CancellationService.shared.getDirectCancellationURL(for: trimmed)?.absoluteString, !detectedURL.contains("google.com/search") {
            linkURL = detectedURL
        } else {
            linkURL = ""
        }
    }
    
    // MARK: - Preset Helper
    private func applyPreset(_ preset: SubscriptionPreset) {
        name = preset.name
        selectedCategory = preset.category
        selectedColorHex = preset.colorHex
        isUserEditedLink = false
        if let presetURL = preset.cancellationUrl {
            linkURL = presetURL
        } else if let detectedURL = CancellationService.shared.getDirectCancellationURL(for: preset.name)?.absoluteString, !detectedURL.contains("google.com/search") {
            linkURL = detectedURL
        } else {
            linkURL = ""
        }
    }
    
    // MARK: - Save Function
    private func saveSubscription() {
        guard isValid else {
            errorMessage = "Please enter a valid subscription name and price."
            showingError = true
            return
        }
        
        guard let costValue = costValue else {
            errorMessage = "Please enter a valid numeric cost."
            showingError = true
            return
        }
        
        isSaving = true
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        var trimmedLink = linkURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // If user left link blank, auto-resolve direct management link for known services
        if trimmedLink.isEmpty, let resolvedURL = CancellationService.shared.getDirectCancellationURL(for: name.trimmingCharacters(in: .whitespacesAndNewlines))?.absoluteString {
            trimmedLink = resolvedURL
        }
        
        let newSubscription = Subscription(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            cost: costValue,
            category: selectedCategory,
            isYearly: isYearly,
            nextBillingDate: nextBillingDate,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes,
            colorHex: selectedColorHex,
            isTrial: false,
            paymentMethod: selectedPaymentMethod.rawValue,
            currency: CurrencyManager.shared.currentCurrency.code,
            reminderDaysBefore: reminderDaysBefore
        )
        newSubscription.isOneTime = isOneTime
        newSubscription.linkURL = trimmedLink.isEmpty ? nil : trimmedLink
        
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

// MARK: - AddSubscriptionColorOptions

struct AddSubscriptionColorOptions {
    static let all: [(name: String, hex: String)] = [
        ("Teal", "#00D4AA"),
        ("Cyan", "#00B4D8"),
        ("Coral", "#FF6B6B"),
        ("Gold", "#FFD93D"),
        ("Orange", "#FF8A5C"),
        ("Purple", "#6C5CE7"),
        ("Lavender", "#A29BFE"),
        ("Gray", "#636E72")
    ]
}

// MARK: - Preview
#Preview {
    AddSubscriptionView()
}
