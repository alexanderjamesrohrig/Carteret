//
//  Storeroom.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

import Foundation
import StoreKit
import OSLog

@MainActor final class Storeroom: ObservableObject {
    typealias SKTransaction = StoreKit.Transaction
    
    enum Item {
        static let allItemIDs: [String] = [
            Item.yearSubscription.productID,
        ]
        
        case yearSubscription
        case lifetime
        
        var referenceName: String {
            switch self {
            case .yearSubscription: "yearly"
            case .lifetime: "lifetime"
            }
        }
        
        var productID: String {
            switch self {
            case .yearSubscription: "cartYearSub"
            case .lifetime: "cartOGYearSub"
            }
        }
        
        var appleID: String {
            switch self {
            case .yearSubscription: "6745236823"
            case .lifetime: "6745236707"
            }
        }
    }
    
    enum Offer {
        case oneMonthOfYearFree
    }
    
    enum Key {
        static let issuerID = "69a6de8c-7f68-47e3-e053-5b8c7c11a4d1"
        case cartYearKey
        
        var id: String {
            switch self {
            case .cartYearKey: "AN3Z27B9BU"
            }
        }
    }
    
    init() {
        updates = Task {
            for await update in SKTransaction.updates {
                if let transaction = try? update.payloadValue {
                    await setActiveTransactions()
                    await transaction.finish()
                }
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
    private let logger = Logger(subsystem: Constant.subsystem, category: "Storeroom")
    
    @Published private(set) var activeTransactions: Set<SKTransaction> = []
    @Published private(set) var activeSubscriptions: Set<String> = []
    private var updates: Task<Void, Never>?
    
    var inventory: [Product] {
        get async {
            do {
                return try await Product.products(for: Item.allItemIDs)
            } catch {
                logger.error("No products found :- \(error.localizedDescription)")
                return []
            }
        }
    }
    
    func purchase(product: Product) async throws -> Bool {
        let result = try await product.purchase()
        switch result {
        case .success(let verificationResult):
            if let transaction = try? verificationResult.payloadValue {
                activeTransactions.insert(transaction)
                await transaction.finish()
            }
            logger.info("Purchased")
            return true
        case .userCancelled:
            logger.info("Canceled purchase")
            return false
        case .pending:
            return false
        @unknown default:
            assertionFailure("Unknown purchase result")
            return false
        }
    }
    
    func setActiveTransactions() async {
        var activeTransactions: Set<SKTransaction> = []
        for await entitlement in SKTransaction.currentEntitlements {
            if let transaction = try? entitlement.payloadValue {
                activeTransactions.insert(transaction)
            }
            switch entitlement {
            case .verified(let transaction):
                activeSubscriptions.insert(transaction.productID)
            default:
                logger.warning("Unverified subscription exists")
            }
        }
        self.activeTransactions = activeTransactions
    }
    
    func hasSubscription(_ item: Item) -> Bool {
        return activeSubscriptions.contains(item.productID)
    }
}
