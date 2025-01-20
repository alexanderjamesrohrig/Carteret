//
//  Loan.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import Foundation
import SwiftData

@Model
final class Loan {
    var name: String
    var interest: Int
    var principal: Int
    var totalAmountDue: Int
    var minimumPayment: Int
    var nextPayment: Int
    var nextPaymentDate: Date
    
    init(name: String,
         interest: Int,
         principal: Int,
         totalAmountDue: Int,
         minimumPayment: Int,
         nextPayment: Int,
         nextPaymentDate: Date) {
        self.name = name
        self.interest = interest
        self.principal = principal
        self.totalAmountDue = totalAmountDue
        self.minimumPayment = minimumPayment
        self.nextPayment = nextPayment
        self.nextPaymentDate = nextPaymentDate
    }
}
