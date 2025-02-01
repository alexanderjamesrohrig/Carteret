//
//  TransactionDestination.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import Foundation

enum TransactionDestination: Codable {
    case safeToSpend, recurringItem, fund
}
