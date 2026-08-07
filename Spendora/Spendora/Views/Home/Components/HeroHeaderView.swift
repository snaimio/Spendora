//
//  HeroHeaderView.swift
//  Spendora
//

import SwiftUI

// MARK: - BillingPeriodFilter Enum

enum BillingPeriodFilter: String, CaseIterable, Identifiable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    case total = "Total"
    
    var id: String { rawValue }
}

// MARK: - HeroHeaderView

/**
 `HeroHeaderView` renders the main executive dashboard hero card featuring:
 - Machined Steel Housing with 4 Corner Brass Rivets
 - Analog Radial Spending Gauge Meter with Polished Brass Needle
 - 38pt Hero Price Display
 - Period Selector Dropdown (Monthly ⌄, Yearly ⌄)
 - Next Charge spotlight card with EVERY DETAIL ON ITS OWN DEDICATED ROW:
   1. Header: NEXT CHARGE
   2. Name: Service Name (20pt Bold Prominent)
   3. Cost: C$XX.XX /month (16pt Heavy Black Vibrant Coral #FF6B6B)
   4. Date: Renewal Date (14pt Regular on dedicated row - NO TEXT BREAKING!)
   5. Badge: Standalone Status Badge Row
 */
struct HeroHeaderView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let subscriptionCount: Int
    let nextSubscription: Subscription?
    
    @State private var selectedPeriod: BillingPeriodFilter = .monthly

    private var budget: Double {
        BudgetService.shared.monthlyBudget
    }
    
    private var budgetRatio: Double {
        BudgetService.shared.progressRatio(currentSpending: totalMonthly)
    }

    private var displayedAmount: Double {
        switch selectedPeriod {
        case .monthly: return totalMonthly
        case .yearly: return totalYearly
        case .total: return totalYearly
        }
    }

    private var periodLabel: String {
        switch selectedPeriod {
        case .monthly: return "THIS MONTH"
        case .yearly: return "YEARLY COMMITMENT"
        case .total: return "TOTAL EXPENDITURE"
        }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 16) {
            // Machined Steel Hero Card Container
            VStack(alignment: .leading, spacing: 16) {
                // Header Row: Period Menu & Active Count
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13, weight: .bold))
                        Text(periodLabel)
                            .font(AppStyles.Typography.footnote)
                            .fontWeight(.bold)
                            .tracking(1.5)
                    }
                    .foregroundColor(Color(hex: "#CBD5E1"))
                    
                    Spacer()
                    
                    // Period Menu Dropdown Pill
                    Menu {
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(BillingPeriodFilter.allCases) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(selectedPeriod.rawValue)
                                .font(AppStyles.Typography.caption2)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(Color(hex: "#D4AF37"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(hex: "#D4AF37").opacity(0.16))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#D4AF37").opacity(0.4), lineWidth: 1)
                        )
                    }
                }
                
                // ANALOG SPENDING GAUGE METER (Physical Luxury Machined Dial)
                VStack(spacing: 8) {
                    ZStack {
                        // Gauge Arc Track
                        Circle()
                            .trim(from: 0.15, to: 0.85)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "#334155"), Color(hex: "#1E293B")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(90))
                            .frame(width: 140, height: 140)
                        
                        // Active Gauge Progress Arc
                        Circle()
                            .trim(from: 0.15, to: 0.15 + max(0, min(0.7, 0.7 * budgetRatio)))
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "#D4AF37"), Color(hex: "#F59E0B")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(90))
                            .frame(width: 140, height: 140)
                            .shadow(color: Color(hex: "#D4AF37").opacity(0.4), radius: 6, x: 0, y: 0)
                        
                        // Analog Gauge Needle
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#F59E0B"), Color(hex: "#D4AF37")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 4, height: 50)
                            .offset(y: -25)
                            .rotationEffect(.degrees(-126 + (252 * max(0, min(1.0, budgetRatio)))))
                            .shadow(color: Color.black.opacity(0.5), radius: 3, x: 1, y: 2)
                        
                        // Center Brass Screw Cap
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#F59E0B"), Color(hex: "#D4AF37")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 16, height: 16)
                            .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                    }
                    .frame(height: 110)
                    
                    HStack {
                        Text("0%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#94A3B8"))
                        Spacer()
                        Text("SPENDING GAUGE (\(Int(budgetRatio * 100))%)")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#D4AF37"))
                            .tracking(1.2)
                        Spacer()
                        Text("100%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#94A3B8"))
                    }
                    .padding(.horizontal, 28)
                }
                
                // Hero Price & Subscription Count
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(CurrencyManager.shared.format(displayedAmount))
                            .font(AppStyles.Typography.heroPrice)
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Text("\(subscriptionCount) \(subscriptionCount == 1 ? "active subscription" : "active subscriptions")")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(Color(hex: "#CBD5E1"))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 11, weight: .bold))
                            Text("Avg: \(CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0))")
                                .font(AppStyles.Typography.caption2)
                        }
                        .foregroundColor(Color(hex: "#D4AF37"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#D4AF37").opacity(0.14))
                        .cornerRadius(8)
                        
                        Text("Yearly: \(CurrencyManager.shared.format(totalYearly))")
                            .font(AppStyles.Typography.caption2)
                            .foregroundColor(Color(hex: "#CBD5E1"))
                            .lineLimit(1)
                    }
                }
                
                // Next Charge Spotlight Section Card (EVERY DETAIL ON ITS OWN DEDICATED ROW)
                if let next = nextSubscription {
                    Divider()
                        .background(Color(hex: "#D4AF37").opacity(0.25))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // ROW 1: Header Label
                        HStack(spacing: 5) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(hex: "#F59E0B"))
                            
                            Text("NEXT CHARGE SPOTLIGHT")
                                .font(AppStyles.Typography.caption2)
                                .foregroundColor(Color(hex: "#CBD5E1"))
                                .tracking(1.2)
                        }
                        
                        // ROW 2: Subscription Name (Title 3 20pt Bold - PROMINENT)
                        Text(next.displayName)
                            .font(AppStyles.Typography.title3)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        // ROW 3: Cost Amount (Vibrant Coral #FF6B6B Heavy Black Font - Consistent Price Color!)
                        HStack(spacing: 4) {
                            Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                                .font(.system(size: 17, weight: .black, design: .rounded))
                                .foregroundColor(Color(hex: "#FF6B6B"))
                            
                            if next.isOneTime {
                                Text("• Lifetime")
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(hex: "#D4AF37"))
                            } else {
                                Text("/month")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(hex: "#CBD5E1"))
                                
                                if next.isYearly {
                                    Text("• Yearly")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(hex: "#CBD5E1"))
                                }
                            }
                        }
                        
                        // ROW 4: Next Billing Date (DEDICATED ROW - NO TEXT BREAKING!)
                        HStack(spacing: 5) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "#D4AF37"))
                            
                            Text("Renewal Date: \(next.formattedNextBillingDate)")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Color(hex: "#CBD5E1"))
                                .lineLimit(1)
                        }
                        
                        // ROW 5: Status Badge ("Due in X days" / "Paid • Xd left") - STANDALONE ROW!
                        CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                            .padding(.top, 2)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#D4AF37").opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(20)
            .background(
                ZStack {
                    // Brushed Gunmetal Base
                    LinearGradient(
                        colors: [Color(hex: "#2B2D32"), Color(hex: "#1A1B1E")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // 4 Corner Brass Rivet Accents
                    VStack {
                        HStack {
                            Circle().fill(Color(hex: "#D4AF37")).frame(width: 6, height: 6)
                            Spacer()
                            Circle().fill(Color(hex: "#D4AF37")).frame(width: 6, height: 6)
                        }
                        Spacer()
                        HStack {
                            Circle().fill(Color(hex: "#D4AF37")).frame(width: 6, height: 6)
                            Spacer()
                            Circle().fill(Color(hex: "#D4AF37")).frame(width: 6, height: 6)
                        }
                    }
                    .padding(10)
                }
            )
            .cornerRadius(22)
            .shadow(color: Color.black.opacity(0.4), radius: 14, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "#D4AF37").opacity(0.5), Color(hex: "#D4AF37").opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .padding(.horizontal, 16)
        }
    }
}
