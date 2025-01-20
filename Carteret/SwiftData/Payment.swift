//
//  Payment.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import Foundation
import SwiftData

@Model
final class Payment {
    var timestamp: Date
    var amount: Int
    var interestAmount: Int
    var principalAmount: Int
    var totalAmountOwedAtTimeOfPayment: Int
    
    init(timestamp: Date,
         amount: Int,
         interestAmount: Int,
         principalAmount: Int,
         totalAmountOwedAtTimeOfPayment: Int) {
        self.timestamp = timestamp
        self.amount = amount
        self.interestAmount = interestAmount
        self.principalAmount = principalAmount
        self.totalAmountOwedAtTimeOfPayment = totalAmountOwedAtTimeOfPayment
    }
}
