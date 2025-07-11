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
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "WeekView")
    let wallet = WalletActor()
    
    @EnvironmentObject private var budgetManager: BudgetManager
    @EnvironmentObject private var debugSettings: DebugSettings
    @Environment(\.modelContext) private var modelContext
    @Query(filter: Transaction.currentWeekPredicate(),
           sort: \.date,
           order: .reverse) private var transactions: [Transaction]
    @State private var showEditTransaction = false
    @State private var showOlderTransactions = false
    @State private var showVisuals = false
    @State private var showImport = false
    @State private var transactionToEdit: Transaction?
    @State private var walletAuthorized: Bool = false
    @State private var walletTransactions: [SendableTransaction] = []
    
    
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
        if safeToSpend == 0 && budgetManager.spendingLimit == 0 && budgetManager.runningBalance == 0 {
            "No budet set up"
        }
        else if safeToSpend > 0 {
            "Safe to spend"
        } else {
            "Over budget"
        }
    }
    
    var olderTransactionsSectionFooter: String {
        guard let start = Calendar.autoupdatingCurrent.currentWeek?.start.medium else {
            assertionFailure("Date error")
            return "Date error"
        }
        return "Transactions made before \(start)."
    }
    
    var body: some View {
        List {
            Section {
                LabeledContent(safeToSpendTitle, value: safeToSpend.display)
                    .popoverTip(CarTip.explainSafeToSpend)
            } header: {
                if let currentWeek {
                    VStack {
                        HStack {
                            Text(currentWeek.start, format: MonthDayFormat())
                            
                            Spacer()
                            
                            Text(currentWeek.end, format: MonthDayFormat())
                        }
                        
                        ProgressView(
                            value: currentWeek.weekProgress,
                            total: currentWeek.weekProgressTotal
                        )
                    }
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
                    
                    ForEach(walletTransactions) { transaction in
                        ImportedTransactionRowView(transaction: transaction)
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
            
            importSection
        }
        .task {
            walletAuthorized = await wallet.authorized
            if #available(iOS 18, *),
               let week = currentWeek,
               let foundWalletTransactions = try? await wallet.transactions(for: week) {
                walletTransactions = foundWalletTransactions
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
    
    @ViewBuilder private var importSection: some View {
        Section {
            Button {
                showImport = true
            } label: {
                Label("Import from Weekly", systemImage: CarteretImage.importName)
            }
            
            if #available(iOS 18.0, *) {
                if wallet.isAvailable && debugSettings.connectToWalletEnabled {
                    if walletAuthorized {
                        Label("Connected to Wallet", systemImage: "checkmark.circle.fill")
                    } else {
                        Button {
                            Task {
                                await wallet.requestAuthorizationSuccess()
                            }
                        } label: {
                            Label("Connect to Wallet", systemImage: "wallet.bifold")
                        }
                    }
                }
            }
        }
    }
}
