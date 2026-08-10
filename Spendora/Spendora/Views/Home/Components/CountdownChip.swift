//
//  CountdownChip.swift
//  Spendora
//

import SwiftUI

// MARK: - CountdownChip (Apple Native Status Badge)

struct CountdownChip: View {
    let daysRemaining: Int
    var isCancelled: Bool = false

    var body: some View {
        StatusBadgeView(daysUntil: daysRemaining, isCancelled: isCancelled)
    }
}
