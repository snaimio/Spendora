//
//  UsageRatingView.swift
//  Spendora
//

import SwiftUI

struct UsageRatingView: View {
    @Binding var rating: Int
    let maximumRating: Int
    let onRatingChanged: ((Int) -> Void)?
    
    init(rating: Binding<Int>, maximumRating: Int = 5, onRatingChanged: ((Int) -> Void)? = nil) {
        self._rating = rating
        self.maximumRating = maximumRating
        self.onRatingChanged = onRatingChanged
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maximumRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.title3)
                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.3))
                    .onTapGesture {
                        rating = index
                        onRatingChanged?(index)
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: rating)
                    .scaleEffect(index == rating ? 1.2 : 1.0)
            }
        }
    }
}
