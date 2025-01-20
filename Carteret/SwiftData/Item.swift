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
         amount: Int,
         type: TransactionType,
         itemRepeat: Repeat,
         category: ItemCategory) {
        self.itemDescription = itemDescription
        self.amount = amount
        self.type = type
        self.itemRepeat = itemRepeat
        self.category = category
    }
    
    init(category: ItemCategory) {
        self.itemDescription = ""
        self.amount = 0
        self.type = .expense
        self.itemRepeat = .everyWeek
        self.category = category
    }

    var itemDescription: String
    var amount: Int
    var type: TransactionType
    var itemRepeat: Repeat
    var category: ItemCategory
    
    var weeklyAmount: Int {
        let amountDouble = Double(amount)
        var weekly: Double = 0.00
        switch itemRepeat {
        case .everyWeek:
            return amount
        case .every2Weeks:
            weekly = amountDouble / 2
        case .twiceAMonth:
            weekly = (amountDouble * 24) / 52
        case .everyMonth:
            weekly = (amountDouble * 12) / 52
        case .everyYear:
            weekly = amountDouble / 52
        }
        return Int(weekly)
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
