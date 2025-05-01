//
//  Untitled.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import Foundation
import SwiftData

@Model
final class Fund {
    static var activeFundsPredicate: Predicate<Fund> {
        return #Predicate<Fund> { fund in
            fund.rawState == 0
        }
    }
    
    static var archivedFundsPredicate: Predicate<Fund> {
        return #Predicate<Fund> { fund in
            fund.rawState == 1
        }
    }
    
    init(description: String,
         goalAmount: Currency,
         transactions: [Transaction],
         fundRepeat: Repeat) {
        self.fundDescription = description
        self.goalAmount = goalAmount
        self.transactions = transactions
        self.fundRepeat = fundRepeat
    }
    
    init() {
        self.fundDescription = ""
        self.goalAmount = Currency.zero
        self.transactions = []
        self.fundRepeat = .none
    }

    var fundDescription: String
    var goalAmount: Currency
    @Relationship(deleteRule: .deny, inverse: \Transaction.fund)
    var transactions: [Transaction]
    var fundRepeat: Repeat
    private var rawState: Int = 0
    
    var currentBalance: Currency {
        return transactions.reduce(Currency.zero) {
            switch $1.type {
            case .expense:
                return $0 - $1.currencyAmount
            case .income:
                return $0 + $1.currencyAmount
            }
        }
    }
    
    var progress: Double {
        (currentBalance / goalAmount).toDouble
    }
    
    var state: StorageState {
        StorageState(rawValue: rawState) ?? .saved
    }
    
    func set(state: StorageState) {
        rawState = state.rawValue
    }
}
