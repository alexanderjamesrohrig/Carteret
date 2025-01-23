//
//  BudgetManager.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import Foundation

class BudgetManager: ObservableObject {
    
    @Published var spendingLimit: Currency = Currency.zero
    @Published var runningBalance: Currency = Currency.zero
    // TODO: Weekly savings $ or %
    
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
