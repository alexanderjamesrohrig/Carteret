enum TransactionType: Int, Codable, CaseIterable {
    case income
    case expense
    
    var displayName: String {
        switch self {
        case .income:
            "Income"
        case .expense:
            "Expense"
        }
    }
}
