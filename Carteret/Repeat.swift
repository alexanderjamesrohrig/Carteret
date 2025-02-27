//
//  Repeat.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

enum Repeat: Int, Codable, CaseIterable {
    case everyWeek
    case every2Weeks
    case twiceAMonth
    case everyMonth
    case everyYear
    case none
    
    static let itemRepeats: [Repeat] = [
        .everyWeek,
        .every2Weeks,
        .twiceAMonth,
        .everyMonth,
        .everyYear
    ]
    
    var displayName: String {
        switch self {
        case .everyWeek:
            "Every week"
        case .every2Weeks:
            "Every 2 weeks"
        case .twiceAMonth:
            "Twice a month"
        case .everyMonth:
            "Every month"
        case .everyYear:
            "Every year"
        case .none:
            "None"
        }
    }
    
    var weeklyMult: Double {
        switch self {
        case .everyWeek:
            1
        case .every2Weeks:
            2
        case .twiceAMonth:
            52 / 12 / 2
        case .everyMonth:
            52 / 12
        case .everyYear:
            52
        case .none:
            0
        }
    }
}
