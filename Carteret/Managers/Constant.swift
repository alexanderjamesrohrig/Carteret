import Foundation

enum Constant {
    /// Subsystem for use in logging
    static let carteretSubsystem = "com.alexanderrohrig.Cateret"
    static let incomeCategoryTitle = "Income"
    static let billsCategoryTitle = "Bills and utilities"
    static let savingsCategoryTitle = "Savings"
    static let prereleaseWarning = "debug.prereleaseWarning"
    static let `nil` = "nil"
    static let zero = "$0.00"
    static let iPhone16CornerRadius: CGFloat = 55.0
    static let maxFreeWeeklyIncome: Currency = 1923.07
    
    static var subsystem: String { carteretSubsystem }
}
