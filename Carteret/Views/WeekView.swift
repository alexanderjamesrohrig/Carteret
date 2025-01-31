//
//  WeekView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog

struct WeekView: View {
    let logger = Logger(subsystem: Constant.carteretSubsystem, category: "WeekView")
    @EnvironmentObject private var budgetManager: BudgetManager
    @Environment(\.modelContext) private var modelContext
    @Query(filter: Transaction.currentWeekPredicate(),
           sort: \.date,
           order: .reverse) private var transactions: [Transaction]
    @State private var showEditTransaction = false
    @State private var showOlderTransactions = false
    @State private var showVisuals = false
    @State private var showImport = false
    @State private var transactionToEdit: Transaction?
    
    
    var currentWeek: Week? {
        Calendar.autoupdatingCurrent.currentWeek
    }
    
    var currentWeekOfYear: Int {
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
            } header: {
                if let value = currentWeek?.weekProgress,
                   let total = currentWeek?.weekProgressTotal {
                    ProgressView(value: value, total: total)
                }
            }
            
            Section {
                Button {
                    showEditTransaction = true
                } label: {
                    Label("New transaction",
                          systemImage: CarteretImage.newTransactionName)
                }
            }
            
            if !transactions.isEmpty {
                Section("Transactions") {
                    ForEach(transactions) { transaction in
                        TransactionRowView(transaction: transaction)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Delete", role: .destructive) {
                                    transactionToEdit = nil
                                    modelContext.delete(transaction)
                                    do {
                                        try modelContext.save()
                                    } catch {
                                        logger.error("\(error.localizedDescription)")
                                    }
                                }
                                
                                Button("Details") {
                                    transactionToEdit = transaction
                                }
                            }
                    }
                }
                
                Section {
                    Button {
                        showVisuals = true
                    } label: {
                        Label("View visuals", systemImage: CarteretImage.visualsName)
                    }
                }
            }
            
            Section {
                // TODO: Switch to navigation link
                Button {
                    showOlderTransactions = true
                } label: {
                    Label("View older transactions",
                          systemImage: CarteretImage.historyName)
                }
            } footer: {
                Text(olderTransactionsSectionFooter)
            }
            
            Section {
                Button {
                    showImport = true
                } label: {
                    Label("Import from Weekly", systemImage: CarteretImage.importName)
                }
            }
        }
        .sheet(isPresented: $showEditTransaction) {
            EditTransactionView(transaction: transactionToEdit)
        }
        .sheet(isPresented: $showOlderTransactions) {
            OlderTransactionsView()
        }
        .sheet(isPresented: $showImport) {
            TransactionImport()
        }
        .sheet(isPresented: $showVisuals) {
            WeekVisuals(transactions: transactions)
        }
        .sheet(item: $transactionToEdit) { transaction in
            EditTransactionView(transaction: transaction)
        }
    }
}
