//
//  SearchBar.swift
//  Spendora
//

import SwiftUI
import UIKit

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .accessibilityHidden(true)
                
                TextField("Search by name or category...", text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .accessibilityLabel("Search subscriptions")
                    .accessibilityHint("Enter subscription name or category to filter results")
                
                if !text.isEmpty {
                    Button(action: {
                        withAnimation {
                            text = ""
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .accessibilityLabel("Clear search")
                    .accessibilityHint("Removes current search text")
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isEditing {
                Button("Cancel") {
                    withAnimation {
                        isEditing = false
                        text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .accessibilityLabel("Cancel search")
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            withAnimation {
                isEditing = true
            }
        }
    }
}
