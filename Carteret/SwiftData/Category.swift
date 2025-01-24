//
//  Category.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import SwiftData

@Model
final class Category {
    init(name: String,
         defaultCategory: DefaultCategory?) {
        self.name = name
        self.id = UUID()
        self.defaultCategory = defaultCategory
    }
    
    init(name: String,
         id: UUID = UUID(),
         defaultCategory: DefaultCategory? = nil) {
        self.name = name
        self.id = id
        self.defaultCategory = defaultCategory
    }
    
    var name: String
    var id: UUID
    var defaultCategory: DefaultCategory?
}

@MainActor
enum DefaultCategory: Codable {
    static let incomeCategory = Category(name: Constant.incomeCategoryTitle,
                                         defaultCategory: .income)
    static let savingsCategory = Category(name: Constant.savingsCategoryTitle,
                                          defaultCategory: .savings)
    static let billsCategory = Category(name: Constant.billsCategoryTitle,
                                        defaultCategory: .billsAndUtilities)
    
    case income, savings, billsAndUtilities
    
    var displayName: String {
        switch self {
        case .income:
            Constant.incomeCategoryTitle
        case .savings:
            Constant.savingsCategoryTitle
        case .billsAndUtilities:
            Constant.billsCategoryTitle
        }
    }
}

// TODO: Custom transaction categories
enum TransactionCategory: Codable, CaseIterable {
    case eatingOut
    case entertainment
    case gas
    case groceries
    case other
    case shopping
    
    var displayName: String {
        switch self {
        case .eatingOut:
            "Eating out"
        case .entertainment:
            "Entertainment"
        case .gas:
            "Gas"
        case .groceries:
            "Groceries"
        case .other:
            "Other"
        case .shopping:
            "Shopping"
        }
    }
}

// TODO: Custom item categories
enum ItemCategory: String, Codable, CaseIterable, Plottable {
    case income
    case savings
    case billsAndUtilities
    case donations
    case healthAndBeauty
    case housing
    case kids
    case loanPayments
    case medical
    case other
    case subscriptions
    case taxes
    case transportation
    
    var displayName: String {
        switch self {
        case .income:
            "Income"
        case .savings:
            "Savings"
        case .billsAndUtilities:
            "Bills and utilities"
        case .donations:
            "Donations"
        case .healthAndBeauty:
            "Health and beauty"
        case .housing:
            "Housing"
        case .kids:
            "Kids"
        case .loanPayments:
            "Loan payments"
        case .medical:
            "Medical"
        case .other:
            "Other"
        case .subscriptions:
            "Subscriptions"
        case .taxes:
            "Taxes"
        case .transportation:
            "Transportation"
        }
    }
}
