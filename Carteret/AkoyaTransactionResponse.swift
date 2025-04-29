//
//  AkoyaTransactionResponse.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/27/25.
//

import Foundation

struct AkoyaTransactionResponse: Codable {
    struct Transaction: Codable {
        struct Common: Codable {
            let accountId: String?
            let amount: Decimal?
            let category: String?
            let debitCreditMemo: String?
            let description: String?
            let imageIds: [String]?
            let foreignAmount: Decimal?
            let foreignCurrency: String?
            let memo: String?
            let postedTimestamp: Date?
            let reference: String?
            let referenceTransactionId: String?
            let status: String?
            let subCategory: String?
            let transactionId: String?
            let transactionTimestamp: Date?
        }
        
        struct Deposit: Codable {
            
        }
        
        struct Insurance: Codable {
            
        }
        
        struct Investment: Codable {
            
        }
        
        struct LineOfCredit: Codable {
            
        }
        
        struct Loan: Codable {
            
        }
        
        let investmentTransaction: Investment?
    }
    
    let transactions: [Transaction]
}
