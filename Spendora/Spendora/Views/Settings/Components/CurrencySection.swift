import SwiftUI

struct CurrencySection: View {
    @ObservedObject private var currencyManager = CurrencyManager.shared
    @State private var selectedCurrency: Currency = .CAD
    
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
