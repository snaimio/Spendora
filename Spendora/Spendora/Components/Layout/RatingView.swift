//
//  RatingView.swift
//

import SwiftUI


// MARK: - RatingView

/**
 `RatingView` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for ratingview handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `RatingView` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct RatingView: View {

    // MARK: - Properties

    @Binding var rating: Int
    let maximumRating: Int  // maximumRating property
    let onRatingChanged: ((Int) -> Void)?  // onRatingChanged property
    
    init(rating: Binding<Int>, maximumRating: Int = 5, onRatingChanged: ((Int) -> Void)? = nil) {
        self._rating = rating
        self.maximumRating = maximumRating
        self.onRatingChanged = onRatingChanged
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        RatingView(rating: .constant(3), maximumRating: 5)
        RatingView(rating: .constant(4), maximumRating: 5)
        RatingView(rating: .constant(0), maximumRating: 5)
    }
    .padding()
}
