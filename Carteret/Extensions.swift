//
//  Extensions.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import OSLog

// MARK: Int
extension Int {
    var display: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let double = Double(self)
        let correctedDecimal = double / 100
        let nsNumber = NSNumber(floatLiteral: correctedDecimal)
        return numberFormatter.string(from: nsNumber) ?? ""
    }
    
    var toDecimal: Double {
        let double = Double(self)
        let withDecimal = double / 100
        return withDecimal
    }
}

// MARK: - Double
extension Double {
    var removeDecimal: Int {
        let noDecimal = self * 100
        return Int(noDecimal)
    }
}

// MARK: - String
extension String {
    var toInt: Int {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        let nsNumber = numberFormatter.number(from: self) ?? 0.00
        let double = Double(truncating: nsNumber)
        let noDecimal = double * 100
        return Int(noDecimal)
    }
}

// MARK: - Calendar
extension Calendar {
    private var logger: Logger {
        Logger(subsystem: Constant.carteretSubsystem, category: "Calendar+")
    }
    
    var currentWeek: Week? {
        self.week(from: Date.now)
    }
    
    func week(from date: Date) -> Week? {
        guard let interval = Self.autoupdatingCurrent.dateInterval(of: .weekOfYear, for: date) else {
            return nil
        }
        let weekOfYear = Self.autoupdatingCurrent.component(.weekOfYear, from: date)
        let week = Week(number: weekOfYear, start: interval.start, end: interval.end)
        logger
            .info("Week \(week.number) \(week.start.description)-\(week.end.description)")
        return week
    }
}

// MARK: - Date
extension Date {
    var medium: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
