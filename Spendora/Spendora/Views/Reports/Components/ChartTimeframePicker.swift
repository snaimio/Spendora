//
//  ChartTimeframePicker.swift
//

import SwiftUI


// MARK: - ChartTimeframePicker

/**
 `ChartTimeframePicker` is a struct that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for charttimeframepicker handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChartTimeframePicker` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
struct ChartTimeframePicker: View {

    // MARK: - Properties

    @Binding var selectedTimeframe: ChartTimeframe
    

// MARK: - ChartTimeframe

/**
 `ChartTimeframe` is a enum that manages core data, layout, or business logic within Spendora.
 
 ## Features
 - Serves as a key component for charttimeframe handling
 - Adheres to Swift single responsibility principles
 - Integrates with SwiftUI reactive state updates
 
 ## Data Flow
 Properties in `ChartTimeframe` are initialized or updated reactively based on user interaction
 and service callbacks.
 
 - Important: Always verify state bindings before executing main thread actions.
 - Note: Part of the Spendora architecture.
 - SeeAlso: `SpendoraApp`
 */
    enum ChartTimeframe: String, CaseIterable {

    // MARK: - Properties

        case monthly = "Monthly"
        case yearly = "Yearly"
    }
    

    // MARK: - Body

    /// Main SwiftUI layout body property.
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
