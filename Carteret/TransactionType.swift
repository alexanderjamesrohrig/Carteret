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
    
    var inverse: Self {
        switch self {
        case .income:
                .expense
        case .expense:
                .income
        }
    }
}
