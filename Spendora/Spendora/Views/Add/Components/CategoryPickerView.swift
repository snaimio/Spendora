//
//  CategoryPickerView.swift
//  Spendora
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var selectedCategory: String
    
    var body: some View {
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
    }
}
