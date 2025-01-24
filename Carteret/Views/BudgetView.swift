//
//  BudgetView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog
import Charts
import RohrigSoftwareCompanyCore

struct BudgetView: View {
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "BudgetView")
    private let debugCategory = Category(name: "Debug")
    let zero = "$0.00"
    
    @EnvironmentObject private var budgetManager: BudgetManager
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showEditItem = false
    @AppStorage(Constant.prereleaseWarning) private var hidePrereleaseWarning = false
    private var itemToEdit: Item?
    
    var spendingLimit: Currency {
        // TODO: Income - bills - savings - funds
        let spendingLimit = incomeTotal - billsTotal
        return spendingLimit
    }
    
    var incomeTotal: Currency {
        var total = Currency.zero
        for item in items where item.isIncome {
            total += item.weeklyAmount
        }
        return total
    }
    
    var billsTotal: Currency {
        var total = Currency.zero
        for item in items where item.isBill {
            total += item.weeklyAmount
        }
        return total
    }
    
    var savingsTotal: Currency {
        var total = Currency.zero
        for item in items where item.isSavings {
            total += item.weeklyAmount
        }
        return total
    }
    
    /// App version
    ///
    /// https://semver.org
    ///
    /// major.minor.patch-prerelease+build
    var appVersion: String { "\(RSCCore.shared.version)-Α+\(RSCCore.shared.build)" }
    
    var body: some View {
        List {
            Section {
                if spendingLimit > 0 {
                    SpendingLimitRow(income: incomeTotal,
                                     bills: billsTotal,
                                     savings: savingsTotal,
                                     spendingLimit: spendingLimit)
                }
                
                LabeledContent("Income", value: incomeTotal.display)
                
                LabeledContent("Bills", value: billsTotal.display)
                
                LabeledContent("Savings", value: zero)
            }
            
            Section("Recurring items") {
                ForEach(items) { item in
                    itemRow(item)
                }
                
                Button("Create a new item") {
                    showEditItem = true
                }
            }
            
#if DEBUG
            Section("DEBUG") {
                LabeledContent("Version", value: appVersion)
                
                Toggle("Hide pre-release warning", isOn: $hidePrereleaseWarning)
            }
#endif
        }
        .sheet(isPresented: $showEditItem) {
            EditItemView(item: itemToEdit)
        }
        .task {
            budgetManager.spendingLimit = spendingLimit
        }
        .safeAreaInset(edge: .bottom) {
            if !hidePrereleaseWarning {
                Text("""
                 You are using an alpha version (\(appVersion)) of Carteret.
                 Be advised data could disappear at any time.
                 This app is unstable and incomplete.
                 """)
                .background(Color(uiColor: .systemBackground))
            }
        }
    }
    
    @ViewBuilder
    func itemRow(_ item: Item) -> some View {
        HStack {
            Text(item.itemDescription)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(item.currencyAmount, format: .currency(code: Locale.currencyCode))
                    .foregroundStyle(color(for: item.type))
                
                Text(item.itemRepeat.displayName)
                    .font(.caption)
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
