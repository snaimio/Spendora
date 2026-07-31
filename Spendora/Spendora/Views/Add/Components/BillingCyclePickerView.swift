import SwiftUI

struct BillingCyclePickerView: View {
    @Binding var isYearly: Bool
    
    var body: some View {
        PremiumFormField(
            icon: "repeat.circle.fill",
            title: "Billing Cycle"
        ) {
            Picker("", selection: $isYearly) {
                Text("Monthly").tag(false)
                Text("Yearly").tag(true)
            }
            .pickerStyle(.segmented)
            .tint(.brandPrimary)
            .frame(maxWidth: 200)
        }
    }
}
