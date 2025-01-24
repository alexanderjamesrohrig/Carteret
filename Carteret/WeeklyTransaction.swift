//
//  WeeklyTransaction.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import Foundation

struct WeeklyTransaction {
    enum Target: String {
        case safeToSpend = "SAFE_TO_SPEND"
        case recurring = "RECURRING"
        case fund = "FUND"
        
        var destination: TransactionDestination {
            switch self {
            case .safeToSpend: .safeToSpend
            case .recurring: .recurringItem
            default: .safeToSpend
            }
        }
    }
    
    static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string) ?? Date.now
    }
    
    static func number(from string: String) -> NSNumber {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string) ?? 0.00
    }
    
    static func target(_ string: String) -> Target {
        if string == Target.recurring.rawValue {
            return .recurring
        } else if string == Target.fund.rawValue {
            return .fund
        } else {
            return .safeToSpend
        }
    }
    
    let id: String
    let title: String
    let date: Date
    let amount: Currency
    let target: Target
    let categoryName: String
    let yearMonth: String
}
