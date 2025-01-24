//
//  TransactionRowView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import SwiftUI

struct TransactionRowView: View {
    let currencyCode = Locale.autoupdatingCurrent.currency?.identifier ?? "USD"
    let transaction: Transaction
    
    var leadingImage: String {
        switch transaction.destination {
        case .recurringItem: "dollarsign.arrow.circlepath"
        case .safeToSpend: "dollarsign.circle"
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: leadingImage)
            
            VStack(alignment: .leading) {
                Text(transaction.date,
                     format: Date.FormatStyle(date: .abbreviated, time: .none))
                .font(.caption)
                
                Text(transaction.transactionDescription)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                CurrencyText(amount: transaction.currencyAmount)
                    .foregroundStyle(color(for: transaction.type))
                
                if let category = transaction.category {
                    Text(category.displayName)
                        .font(.caption)
                }
                
                if let recurringItem = transaction.item {
                    Text(recurringItem.itemDescription)
                        .font(.caption)
                }
            }
        }
    }
    
    func color(for transactionType: TransactionType) -> Color {
        switch transactionType {
        case .income:
            Color.green
        case .expense:
            Color.red
        }
    }
}
