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
    var interest: Decimal
    var principal: Currency
    var totalAmountDue: Currency
    var minimumPayment: Currency
    var nextPayment: Currency
    var nextPaymentDate: Date
    
    init(name: String,
         interest: Decimal,
         principal: Currency,
         totalAmountDue: Currency,
         minimumPayment: Currency,
         nextPayment: Currency,
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
