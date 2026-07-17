//
//  AddNotesView.swift
//  Spendora
//

import SwiftUI

struct AddNotesView: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes (Optional)")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            TextField("Add notes...", text: $notes, axis: .vertical)
                .font(.system(.body, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 16)
                .lineLimit(3...6)
        }
    }
}
