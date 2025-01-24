//
//  Item.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    init(itemDescription: String,
         amount: Currency,
         type: TransactionType,
         itemRepeat: Repeat,
         category: ItemCategory,
         transactions: [Transaction] = []) {
        self.itemDescription = itemDescription
        self.currencyAmount = amount
        self.type = type
        self.itemRepeat = itemRepeat
        self.category = category
        self.transactions = transactions
    }
    
    init(category: ItemCategory) {
        self.itemDescription = ""
        self.currencyAmount = Currency.zero
        self.type = .expense
        self.itemRepeat = .everyWeek
        self.category = category
        self.transactions = []
    }

    var itemDescription: String
    @available(*,
                deprecated,
                renamed: "amountDecimal",
                message: "Causes incorrect calculations.")
    var amount: Int = 0
    var currencyAmount: Currency
    // TODO: Add Decimal amount
    var type: TransactionType
    var itemRepeat: Repeat
    var category: ItemCategory
    @Relationship(deleteRule: .deny, inverse: \Transaction.item)
    var transactions: [Transaction]
    
    var weeklyAmount: Currency {
        var weekly = Currency.zero
        switch itemRepeat {
        case .everyWeek:
            return currencyAmount
        case .every2Weeks:
            weekly = currencyAmount / 2
        case .twiceAMonth:
            weekly = (currencyAmount * 24) / 52
        case .everyMonth:
            weekly = (currencyAmount * 12) / 52
        case .everyYear:
            weekly = currencyAmount / 52
        }
        return weekly
    }
    
    var isBill: Bool {
        type == .expense && (category != .savings && category != .income)
    }
    
    var isIncome: Bool {
        type == .income && category == .income
    }
    
    var isSavings: Bool {
        type == .expense && category == .savings
    }
}
