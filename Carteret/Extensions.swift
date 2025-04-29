//
//  Extensions.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import OSLog
import SwiftUI

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
    @available(*, unavailable, message: "Results in incorrect value")
    var removeDecimal: Int {
        let noDecimal = self * 100
        return Int(noDecimal)
    }
}

// MARK: - String
extension String {
    @available(*, unavailable, message: "Results in incorrect value")
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

// MARK: - Locale
extension Locale {
    /// Auto updating current currency code, defaults to USD
    static var currencyCode: String {
        Self.autoupdatingCurrent.currency?.identifier ?? "USD"
    }
    
    /// https://gist.github.com/christianselig/09383de004bd878ba4a86663bc6d1b0b
    private var currencySymbolName: String? {
        guard let currencySymbol else {
            return nil
        }
        let symbols: [String: String] = [
            "$": "dollar",
            "¢": "cent",
            "¥": "yen",
            "£": "sterling",
            "₣": "franc",
            "ƒ": "florin",
            "₺": "turkishlira",
            "₽": "ruble",
            "€": "euro",
            "₫": "dong",
            "₹": "indianrupee",
            "₸": "tenge",
            "₧": "peseta",
            "₱": "peso",
            "₭": "kip",
            "₩": "won",
            "₤": "lira",
            "₳": "austral",
            "₴": "hryvnia",
            "₦": "naira",
            "₲": "guarani",
            "₡": "coloncurrency",
            "₵": "cedi",
            "₢": "cruzeiro",
            "₮": "tugrik",
            "₥": "mill",
            "₪": "shekel",
            "₼": "manat",
            "₨": "rupee",
            "฿": "baht",
            "₾": "lari",
            "R$":" brazilianreal"
        ]
        guard let symbolName = symbols[currencySymbol] else {
            return nil
        }
        return "\(symbolName)sign"
    }
    
    /// https://gist.github.com/christianselig/09383de004bd878ba4a86663bc6d1b0b
    func currencySymbol(systemName: String,
                        filled: Bool = false,
                        with configuration: UIImage.Configuration? = nil) -> UIImage {
        let filled = filled ? ".fill" : ""
        let defaultName = "dollarsign.\(systemName)\(filled)"
        let defaultImage = UIImage(systemName: defaultName)!
        guard let currencySymbolName = currencySymbolName else {
            return defaultImage
        }
        let symbolName = "\(currencySymbolName)\(systemName)\(filled)"
        return UIImage(systemName: symbolName,
                       withConfiguration: configuration) ?? defaultImage
    }
}

// MARK: - Decimal
extension Decimal {
    static var zero: Decimal {
        return Decimal(string: "0.00", locale: Locale.autoupdatingCurrent) ?? 0.00
    }
    
    static func from(string: String) -> Decimal {
        return Decimal(string: string, locale: Locale.autoupdatingCurrent) ?? 0.00
    }
    
    var display: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: NSDecimalNumber(decimal: self)) ?? ""
    }
    
    var toDouble: Double {
        let nsdn = NSDecimalNumber(decimal: self)
        return Double(truncating: nsdn)
    }
}

// MARK: - View
extension View {
    func height(_ height: Binding<CGFloat>) -> some View {
        self.modifier(Height(height: height))
    }
}

// MARK: - Data
extension Data {
    var toString: String {
        String(data: self, encoding: .utf8) ?? "nil"
    }
}
