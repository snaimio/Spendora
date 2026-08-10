//
//  SubscriptionRow.swift
//  Spendora
//

import SwiftUI

// MARK: - SubscriptionRow (Golden UX List Row Component)

struct SubscriptionRow: View {

    // MARK: - Properties

    let subscription: Subscription

    private var rowColor: Color {
        subscription.categoryEnum.color
    }

    private var rowIcon: String {
        UniqueSubscriptionThemeHelper.resolveIcon(for: subscription)
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .top, spacing: SpendoraTheme.Spacing.md) {
            // Leading icon container: 46x46pt, 14pt radius, 20% opacity background
            ZStack {
                RoundedRectangle(cornerRadius: SpendoraTheme.Radius.iconBox, style: .continuous)
                    .fill(rowColor.opacity(0.20))
                    .frame(width: 46, height: 46)
                
                Image(systemName: rowIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(rowColor)
            }
            .frame(width: 46)
            
            // Content Stack
            VStack(alignment: .leading, spacing: SpendoraTheme.Spacing.xs) {
                // ROW 1: Subscription Name (17pt semibold charcoal) + Chevron #FFB3A7 (13pt)
                HStack(alignment: .center) {
                    Text(subscription.displayName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(SpendoraTheme.Colors.chevron)
                }
                
                // ROW 2: Category in category color, bullet · separator, cycle plain secondary
                HStack(spacing: 4) {
                    Text(subscription.effectiveCategory)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(rowColor)
                    
                    Text("·")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SpendoraTheme.Colors.textTertiary)
                    
                    Text(subscription.isOneTime ? "Lifetime" : (subscription.isYearly ? "Yearly" : "Monthly"))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                }
                
                // ROW 3: Cost (15pt semibold monospaced charcoal) + "Next: date" (13pt secondary right aligned)
                HStack(spacing: 4) {
                    Text(CurrencyManager.shared.format(subscription.isOneTime ? subscription.cost : subscription.monthlyCost))
                        .font(Font.system(size: 15, weight: .semibold, design: .default).monospacedDigit())
                        .foregroundColor(SpendoraTheme.Colors.textPrimary)
                    
                    Text(subscription.isOneTime ? "total" : "/month")
                        .font(SpendoraTheme.Typography.caption)
                        .foregroundColor(SpendoraTheme.Colors.textSecondary)
                    
                    Spacer()
                    
                    if !subscription.isOneTime {
                        Text("Next: \(subscription.formattedNextBillingDate)")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(SpendoraTheme.Colors.textSecondary)
                            .lineLimit(1)
                    }
                }
                
                // ROW 4: Status badge left aligned, 8pt top spacing from row 3
                CountdownChip(daysRemaining: subscription.daysUntilBilling, isCancelled: subscription.isCancelled)
                    .padding(.top, 8)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(SpendoraTheme.Spacing.lg)
        .spendoraCard(cornerRadius: SpendoraTheme.Radius.card)
        .pressableCard()
    }
}
