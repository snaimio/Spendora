//
//  CurrencySection.swift
//

import SwiftUI


// MARK: - CurrencySection

/**
 `CurrencySection` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for currencysection handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `CurrencySection` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct CurrencySection: View {

    // MARK: - Properties

    @ObservedObject private var currencyManager = CurrencyManager.shared
    @State private var selectedCurrency: Currency = .CAD
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
    var body: some View {
        Section {
            Picker("Select Currency", selection: $selectedCurrency) {
                ForEach(Currency.allCases) { currency in
                    Text(currency.pickerLabel)
                        .tag(currency)
                }
            }
            .onChange(of: selectedCurrency) { _, newValue in
                currencyManager.setCurrency(newValue)
            }
            
            Text("All amounts will be formatted in \(currencyManager.currentCurrency.name) (\(currencyManager.currentCurrency.symbol.trimmingCharacters(in: .whitespaces)))")
                .font(.system(.caption, design: .rounded))
                .foregroundColor(.secondary)
        } header: {
            Text("Currency")
        } footer: {
            Text("Change how subscription costs are displayed")
                .font(.system(.caption, design: .rounded))
        }
        .onAppear {
            selectedCurrency = currencyManager.currentCurrency
        }
    }
}
