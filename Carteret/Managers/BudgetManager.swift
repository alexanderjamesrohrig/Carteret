//
//  BudgetManager.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import Foundation

class BudgetManager: ObservableObject {
    enum BudgetBreakdownStyle {
        case currency, percentage
    }
    
    @Published var spendingLimit: Currency = Currency.zero
    @Published var runningBalance: Currency = Currency.zero
    // TODO: Toggle to see spending limit, bills, savings as %
    @Published var breakdownStyle: BudgetBreakdownStyle = .currency
    // TODO: Weekly savings $ or %
    @Published var weeklySavings: Currency = .zero
    
    var displaySpendingLimit: String {
        spendingLimit.display
    }
    
    func calculateBalance(from transactions: [Transaction]) {
        var total = Currency.zero
        for transaction in transactions {
            switch transaction.type {
            case .expense: total -= transaction.currencyAmount
            case .income: total += transaction.currencyAmount
            }
        }
        runningBalance = total
    }
}
