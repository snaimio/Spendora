//
//  ChartTimeframePicker.swift
//  Spendora
//

import SwiftUI

struct ChartTimeframePicker: View {
    @Binding var selectedTimeframe: ChartTimeframe
    
    enum ChartTimeframe: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    
    var body: some View {
        Picker("Timeframe", selection: $selectedTimeframe) {
            ForEach(ChartTimeframe.allCases, id: \.self) { timeframe in
                Text(timeframe.rawValue).tag(timeframe)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}
