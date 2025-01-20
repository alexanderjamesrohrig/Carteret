//
//  BudgetManager.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import Foundation

class BudgetManager: ObservableObject {
    init() {
        self.spendingLimit = 0
    }
    
    @Published var spendingLimit: Int
    
    var displaySpendingLimit: String {
        spendingLimit.display
    }
}
