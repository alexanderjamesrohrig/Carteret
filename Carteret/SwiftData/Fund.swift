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
    init(description: String,
         goalAmount: Currency,
         transactions: [Transaction],
         fundRepeat: Repeat) {
        self.fundDescription = description
        self.goalAmount = goalAmount
        self.transactions = transactions
        self.fundRepeat = fundRepeat
    }

    var fundDescription: String
    var goalAmount: Currency
    var transactions: [Transaction]
    var fundRepeat: Repeat
}
