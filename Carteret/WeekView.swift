//
//  WeekView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import Foundation
import SwiftUI
import SwiftData

struct WeekView: View {
    @EnvironmentObject private var budgetManager: BudgetManager
    @Environment(\.modelContext) private var modelContext
    @Query(filter: Transaction.currentWeekPredicate(),
           sort: \.date,
           order: .reverse) private var transactions: [Transaction]
    @State private var showEditTransaction = false
    @State private var showOlderTransactions = false
    private var transactionToEdit: Transaction?
    
    var currentWeek: Int {
        let calendar = Calendar.autoupdatingCurrent
        let weekOfYear = calendar.component(.weekOfYear, from: Date.now)
        return weekOfYear
    }
    
    var weekExpenses: Currency {
        var total = Currency.zero
        for transaction in transactions where transaction.safeToSpendExpense {
            total += transaction.currencyAmount
        }
        return total
    }
    
    var weekIncome: Currency {
        var total = Currency.zero
        for transaction in transactions where transaction.safeToSpendIncome {
            total += transaction.currencyAmount
        }
        return total
    }
    
    var safeToSpend: Currency {
        return budgetManager.spendingLimit - weekExpenses + weekIncome
    }
    
    var safeToSpendTitle: String {
        if safeToSpend > 0 {
            "Safe to spend"
        } else {
            "Over budget"
        }
    }
    
    var olderTransactionsSectionFooter: String {
        guard let start = Calendar.autoupdatingCurrent.currentWeek?.start.medium else {
            return "Date error"
        }
        return "Transactions made before \(start)."
    }
    
    var body: some View {
        List {
            Section {
                LabeledContent(safeToSpendTitle, value: safeToSpend.display)
            }
            
            Section {
                Button {
                    // TODO: New transaction
                    showEditTransaction = true
                } label: {
                    Label("New transaction",
                          systemImage: CarteretImage.newTransactionName)
                }
            }
            
            Section("Transactions") {
                ForEach(transactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
            
            Section {
                // TODO: Switch to navigation link
                Button("View older transactions") {
                    showOlderTransactions = true
                }
            } footer: {
                Text(olderTransactionsSectionFooter)
            }
        }
        .sheet(isPresented: $showEditTransaction) {
            EditTransactionView(transaction: transactionToEdit)
        }
        .sheet(isPresented: $showOlderTransactions) {
            OlderTransactionsView()
                .presentationDragIndicator(.visible)
        }
    }
}
