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

struct BudgetView: View {
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "BudgetView")
    private let debugCategory = Category(name: "Debug")
    let zero = "$0.00"
    
    @EnvironmentObject private var budgetManager: BudgetManager
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showEditItem = false
    private var itemToEdit: Item?
    
    var spendingLimit: Int {
        // TODO: Income - bills - savings - funds
        let spendingLimit = incomeTotal - billsTotal
        return spendingLimit
    }
    
    var incomeTotal: Int {
        var total = 0
        for item in items where item.isIncome {
            total += item.weeklyAmount
        }
        return total
    }
    
    var billsTotal: Int {
        var total = 0
        for item in items where item.isBill {
            total += item.weeklyAmount
        }
        return total
    }
    
    var savingsTotal: Int {
        var total = 0
        for item in items where item.isSavings {
            total += item.weeklyAmount
        }
        return total
    }
    
    var body: some View {
        List {
            Section {
                LabeledContent("Spending limit", value: spendingLimit.display)
                
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
            Section("DEBUG") {}
            #endif
        }
        .sheet(isPresented: $showEditItem) {
            EditItemView(item: itemToEdit)
        }
        .task {
            budgetManager.spendingLimit = spendingLimit
        }
    }
    
    @ViewBuilder
    func itemRow(_ item: Item) -> some View {
        HStack {
            Text(item.itemDescription)
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.amount.display)
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

#Preview {
    BudgetView()
}
