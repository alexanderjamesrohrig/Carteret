//
//  WalletActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

import Foundation
import OSLog
#if canImport(FinanceKitUI)
import FinanceKit
import FinanceKitUI

//struct FinanceKitManager {
//    let store = FinanceStore.shared
//    private let logger = Logger(
//        subsystem: Constant.subsystem,
//        category: "FinanceKitManager")
//    
//    var isAvailable: Bool {
//        FinanceStore.isDataAvailable(.financialData)
//    }
//    
//    func accounts() async -> [FinanceKit.Account] {
//        guard isAvailable,
//              await authorized() else {
//            return []
//        }
//        do {
//            let sortDescriptor = SortDescriptor(\FinanceKit.Account.displayName)
////            let predicate = #Predicate<FinanceKit.Account> { account in
////                return true
////            }
//            let query = AccountQuery(sortDescriptors: [sortDescriptor])
//            let accounts = try await store.accounts(query: query)
//            return accounts
//        } catch {
//            logger.error("Account query error")
//            return []
//        }
//    }
//    
//    func authorized() async -> Bool {
//        do {
//            let authorized = try await store.authorizationStatus()
//            switch authorized {
//            case .notDetermined:
//                return false
//            case .denied:
//                return false
//            case .authorized:
//                return true
//            @unknown default:
//                logger.error("Found unknown status")
//                return false
//            }
//        } catch {
//            logger.error("Authorization error")
//            return false
//        }
//    }
//    
//    func authorizedAndRequest() async -> Bool {
//        do {
//            let authorized = try await store.requestAuthorization()
//            switch authorized {
//            case .notDetermined:
//                return false
//            case .denied:
//                return false
//            case .authorized:
//                return true
//            @unknown default:
//                logger.error("Found unknown status")
//                return false
//            }
//        } catch {
//            logger.error("Request authorization error")
//            return false
//        }
//    }
//    
//    func transactions() async -> [Transaction] {
//        guard #available(iOS 18, *) else {
//            return []
//        }
//        do {
//            let sortByTransactionDate = SortDescriptor(\FinanceKit.Transaction.transactionDate)
//            let query = TransactionQuery(
//                sortDescriptors: [sortByTransactionDate])
//            let transactions = try await store.transactions(query: query)
//            var mapped: [Transaction] = []
//            for transaction in transactions {
//                if let mappedTransaction = transaction.toCarteretTransaction {
//                    mapped.append(mappedTransaction)
//                }
//            }
//            return mapped
//        } catch {
//            logger.error("Transaction query error")
//            return []
//        }
//    }
//    
    // TODO: All transactions
//    func allTransaction() async -> [Transaction] {
//        let accounts = await accounts()
//        guard !accounts.isEmpty else {
//            return []
//        }
//        for account in accounts {
//            store.
//        }
//    }
//}

extension FinanceKit.Transaction {
    @available(iOS 18, *)
    var toCarteretTransaction: Transaction? {
        guard let currentCurrencyCode = Locale.autoupdatingCurrent.currency?.identifier else {
            print("Error - Found foreign transaction with no current locale")
            return nil
        }
        let amount: Decimal
        if currentCurrencyCode != self.transactionAmount.currencyCode,
           let foreignAmount = self.foreignCurrencyAmount?.amount,
           let foreignExchangeRate = self.foreignCurrencyExchangeRate {
            amount = foreignAmount * foreignExchangeRate
        } else {
            amount = self.transactionAmount.amount
        }
        let type: TransactionType
        switch self.creditDebitIndicator {
        case .credit:
            type = .income
        case .debit:
            type = .expense
        @unknown default:
            print("Error - Unknown transaction type")
            fatalError()
        }
        return Transaction(
            destination: .safeToSpend, // FIXME: Let user assign Item something to take recurring item from Wallet
            category: .other, // FIXME: Convert from ISO 18245
            item: nil,
            fund: nil,
            amount: amount,
            type: type,
            transactionDescription: self.originalTransactionDescription,
            date: self.transactionDate)
    }
}

actor WalletActor {
    typealias FKTransaction = FinanceKit.Transaction
    
    enum WalletError: Error {
        
    }
    
    private let logger = Logger(subsystem: Constant.subsystem, category: "WalletActor")
    
    private var store: FinanceStore { FinanceStore.shared }
    
    var authorized: Bool {
        get async {
            do {
                let authorized = try await store.authorizationStatus()
                switch authorized {
                case .notDetermined:
                    return false
                case .denied:
                    return false
                case .authorized:
                    return true
                @unknown default:
                    assertionFailure("Unknown authorization status")
                    return false
                }
            } catch {
                logger.error("Authorization :- \(error.localizedDescription)")
                return false
            }
        }
    }
    
    @MainActor var isAvailable: Bool { FinanceStore.isDataAvailable(.financialData) }
    
    func requestAuthorizationSuccess() async -> Bool {
        do {
            return try await store.requestAuthorization() == .authorized
        } catch {
            return false
        }
    }
    
    func historyToken(from week: Week) {}
    
    func accounts() async {
        let accounts = store.accountHistory()
    }
    
    func transactions(for week: Week) async throws -> [FKTransaction] {
        let sortDescriptors: [SortDescriptor<FKTransaction>] = []
        let query = TransactionQuery(
            sortDescriptors: sortDescriptors,
            predicate: nil,
            limit: nil,
            offset: nil
        )
        return []
    }
}
#endif
