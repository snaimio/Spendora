//
//  CurrencySection.swift
//  Spendora
//

import SwiftUI

struct CurrencySection: View {
    @ObservedObject private var currencyManager = CurrencyManager.shared
    @State private var selectedCurrency: Currency = .CAD
    
    var body: some View {
        Section {
            Picker("Select Currency", selection: $selectedCurrency) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    HStack {
                        Text(currency.symbol)
                        Text(currency.code)
                    }
                    .tag(currency)
                }
            }
            .onChange(of: selectedCurrency) { _, newValue in
                currencyManager.setCurrency(newValue)
            }
            
            Text("All amounts will be shown in \(currencyManager.currentCurrency.symbol) (\(currencyManager.currentCurrency.code))")
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
