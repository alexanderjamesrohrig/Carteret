//
//  CitiTransaction.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/27/25.
//

import Foundation

struct CitiTransaction {
    enum Status: String {
        case cleared = "Cleared"
    }
    
    static func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: string)
    }
    
    let status: String
    let date: Date
    let description: String
    let debit: Decimal
    let credit: Decimal
    let memberName: String
}
