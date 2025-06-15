//
//  ImportedTransactionRowView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/15/25.
//

import SwiftUI

struct ImportedTransactionRowView: View {
    let transaction: SendableTransaction
    
    var body: some View {
        HStack {
            Image(systemName: "square.and.arrow.down")
            
            VStack(alignment: .leading) {
                Text(transaction.date,
                     format: Date.FormatStyle(date: .abbreviated, time: .none))
                .font(.caption)
                
                Text(transaction.description)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                CurrencyText(amount: transaction.amount)
                    .foregroundStyle(color(for: transaction.type))
                
                if let category = transaction.category {
                    Text(category)
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
