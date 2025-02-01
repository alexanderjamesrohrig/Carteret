//
//  FormatStyle.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/31/25.
//

import Foundation

struct MonthDayFormat: FormatStyle {
    func format(_ value: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: value)
    }
}
