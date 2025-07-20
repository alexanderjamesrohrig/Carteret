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
    static func activeItemsPredicate() -> Predicate<Item> {
        return #Predicate<Item> { item in
            item.rawState == 0
        }
    }
    
    static func archivedItemsPredicate() -> Predicate<Item> {
        return #Predicate<Item> { item in
            item.rawState == 1
        }
    }
    
    init(itemDescription: String,
         amount: Currency,
         type: TransactionType,
         itemRepeat: Repeat,
         category: ItemCategory,
         transactions: [Transaction] = [],
         state: StorageState = .saved) {
        self.itemDescription = itemDescription
        self.currencyAmount = amount
        self.type = type
        self.itemRepeat = itemRepeat
        self.category = category
        self.transactions = transactions
        self.rawState = state.rawValue
    }
    
    init(category: ItemCategory) {
        self.itemDescription = ""
        self.currencyAmount = Currency.zero
        self.type = .expense
        self.itemRepeat = .everyWeek
        self.category = category
        self.transactions = []
        self.rawState = StorageState.saved.rawValue
    }

    var itemDescription: String
    var currencyAmount: Currency
    var type: TransactionType
    var itemRepeat: Repeat
    var category: ItemCategory
    @Relationship(deleteRule: .deny, inverse: \Transaction.item)
    var transactions: [Transaction]
    private var rawState: Int = 0
    
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
        case .everySixMonths:
            weekly = currencyAmount / 26
        case .everyYear:
            weekly = currencyAmount / 52
        case .none:
            return weekly
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
    
    var state: StorageState {
        StorageState(rawValue: rawState) ?? .saved
    }
    
    func set(state: StorageState) {
        rawState = state.rawValue
    }
}
