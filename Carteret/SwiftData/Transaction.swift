//
//  Transaction.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import SwiftData
import OSLog

@Model
final class Transaction {
    static func currentWeekPredicate() -> Predicate<Transaction> {
        guard let currentWeek = Calendar.autoupdatingCurrent.currentWeek else {
            return .false
        }
        return #Predicate<Transaction> { transaction in
            transaction.date >= currentWeek.start && transaction.date <= currentWeek.end
        }
    }
    
    static func beforeCurrentWeekPredicate() -> Predicate<Transaction> {
        guard let currentWeek = Calendar.autoupdatingCurrent.currentWeek else {
            return .false
        }
        return #Predicate<Transaction> { transaction in
            transaction.date < currentWeek.start
        }
    }
    
    init(destination: TransactionDestination,
         category: TransactionCategory?,
         item: Item?,
         amount: Currency,
         type: TransactionType,
         transactionDescription: String,
         date: Date) {
        self.destination = destination
        self.category = category
        self.item = item
        self.currencyAmount = amount
        self.type = type
        self.transactionDescription = transactionDescription
        self.date = date
    }
    
    var destination: TransactionDestination
    var category: TransactionCategory?
    @Relationship(deleteRule: .nullify)
    var item: Item?
    @available(*, deprecated,
                renamed: "amountDecimal",
                message: "Causes incorrect calculations.")
    var amount: Int = 0
    var currencyAmount: Currency
    var type: TransactionType
    var transactionDescription: String
    var date: Date
    
    var displayAmount: String {
        amount.display
    }
    
    var safeToSpendIncome: Bool {
        type == .income && category != nil
    }
    
    var safeToSpendExpense: Bool {
        type == .expense && category != nil
    }
}
