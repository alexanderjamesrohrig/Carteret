//
//  SendableTransaction.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/15/25.
//

import Foundation

struct SendableTransaction: Identifiable {
    let id = UUID()
    let date: Date
    let description: String
    let type: TransactionType
    let amount: Currency
    let category: String?
}
