//
//  HomeHeaderCards.swift
//  Spendora
//

import SwiftUI

// MARK: - HeroCardView

/**
 `HeroCardView` renders the dashboard top spending card & Next Charge spotlight row:
 - Single line Next Charge Spotlight with 15pt bold text
 - Currency and renewal date locked on 1 single row (no multi-line breaking!)
 */
struct HeroCardView: View {

    // MARK: - Properties

    let totalMonthly: Double
    let totalYearly: Double
    let count: Int
    let subscriptionCount: Int
    var nextSubscription: Subscription? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FF6B6B"), Color(hex: "#FFE66D")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 4)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
                .padding(.top, 12)

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("THIS MONTH")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.textSecondary)
                        .tracking(1.5)
                    
                    Text(CurrencyManager.shared.format(totalMonthly))
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    if count > 0 {
                        Text("\(count) active \(count == 1 ? "subscription" : "subscriptions")")
                            .font(.system(.caption, design: .rounded))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 8)
                
                VStack(alignment: .trailing, spacing: 6) {
                    HeroPill(
                        icon: "calendar",
                        label: "Yearly",
                        value: CurrencyManager.shared.format(totalYearly),
                        color: Color(hex: "#4ECDC4")
                    )
                    
                    HeroPill(
                        icon: "chart.line.uptrend.xyaxis",
                        label: "Avg",
                        value: CurrencyManager.shared.format(subscriptionCount > 0 ? totalMonthly / Double(subscriptionCount) : 0),
                        color: Color(hex: "#A29BFE")
                    )
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, nextSubscription != nil ? 6 : 12)
            
            // Next Charge Spotlight Row (Single Line, Bigger Font, Zero Line Breaking!)
            if let next = nextSubscription {
                Divider()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "bell.badge.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "#F59E0B"))
                            
                            Text("NEXT CHARGE")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.textSecondary)
                                .tracking(1.2)
                        }
                        
                        Spacer()
                        
                        CountdownChip(daysRemaining: next.daysUntilBilling, isCancelled: next.isCancelled)
                    }
                    
                    // Single Line Prominent Price & Date Row (Bigger Font, Single Line Locked!)
                    HStack(alignment: .firstTextBaseline) {
                        Text(next.displayName)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.textPrimary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Text(CurrencyManager.shared.format(next.isOneTime ? next.cost : next.monthlyCost))
                                .font(.system(size: 16, weight: .black, design: .rounded))
                                .foregroundColor(Color(hex: "#FF6B6B"))
                            
                            Text("•")
                                .foregroundColor(Color(hex: "#D4AF37"))
                            
                            Text(next.formattedNextBillingDate)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#D4AF37"))
                        }
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
        .background(Color.cardBackground)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.06), radius: 15, x: 0, y: 4)
    }
}


// MARK: - HeroPill

struct HeroPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(color)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundColor(.textSecondary)
            Text(value)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.cardBackground)
                .shadow(color: Color.black.opacity(0.04), radius: 4)
        )
    }
}
