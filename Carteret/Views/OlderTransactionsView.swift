//
//  OlderTransactionsView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import SwiftUI
import SwiftData

struct OlderTransactionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(filter: Transaction.beforeCurrentWeekPredicate(),
           sort: \.date,
           order: .reverse) private var transactions: [Transaction]
    
    var body: some View {
        if transactions.isEmpty {
            VStack(alignment: .center) {
                Spacer()
                
                ContentUnavailableView("No transactions", systemImage: "bag")
                
                Spacer()
            }
            .presentationDragIndicator(.visible)
        } else {
            List {
                ForEach(transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    OlderTransactionsView()
}
