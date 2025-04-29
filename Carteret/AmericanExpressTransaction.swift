//
//  AmericanExpressTransaction.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/27/25.
//

import Foundation

struct AmericanExpressTransaction {
    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: string)
    }
    
    let date: Date
    let description: String
    let cardMember: String
    let accountNumber: String
    let amount: Decimal
    let extendedDetails: String?
    let appearsOnYourStatementAs: String
    let address: String
    let cityState: String
    let zipCode: String
    let country: String
    let reference: String
    let category: String
}
