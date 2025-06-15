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

actor WalletActor {
    typealias FKTransaction = FinanceKit.Transaction
    
    enum WalletError: Error {
        case walletNotAvailable
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
    
    func accounts() async -> [FinanceKit.Account] {
        do {
            let sortDescriptor = SortDescriptor(\FinanceKit.Account.displayName)
//            let predicate = #Predicate<FinanceKit.Account> { account in
//                return true
//            }
            let query = AccountQuery(sortDescriptors: [sortDescriptor])
            let accounts = try await store.accounts(query: query)
            return accounts
        } catch {
            logger.error("Account query error")
            return []
        }
    }
    
    func transactions(
        for account: FinanceKit.Account
    ) async -> [FinanceKit.Transaction] {
        do {
            let sort = SortDescriptor(\FinanceKit.Transaction.transactionDate)
            let query = TransactionQuery(sortDescriptors: [sort])
            let transactions = try await store.transactions(query: query)
            return transactions
        } catch {
            logger.error("Transaction query error")
            return []
        }
    }
    
    @available(iOS 18, *)
    func allTransactionsFromAllAccounts() async throws -> [SendableTransaction] {
        guard await isAvailable,
              await authorized else {
            throw WalletError.walletNotAvailable
        }
        var fkTransactions: [FinanceKit.Transaction] = []
        let fkAccounts = await accounts()
        for account in fkAccounts {
            let transactions = await transactions(for: account)
            fkTransactions.append(contentsOf: transactions)
        }
        let sTransactions: [SendableTransaction] = fkTransactions.map {
            $0.toSendableTransaction
        }
        return sTransactions
    }
    
    @available(iOS 18, *)
    func transactions(
        for week: Week
    ) async throws -> [SendableTransaction] {
        guard await isAvailable,
              await authorized else {
            throw WalletError.walletNotAvailable
        }
        let startDate = Date.distantPast //week.start
        var fkTransactions: [FinanceKit.Transaction] = []
        let sort = SortDescriptor(\FinanceKit.Transaction.transactionDate)
        let predicate = #Predicate<FinanceKit.Transaction> { transaction in
            transaction.transactionDate >= startDate
        }
        let query = TransactionQuery(
            sortDescriptors: [sort],
            predicate: predicate)
        let transactions = try await store.transactions(query: query)
        fkTransactions.append(contentsOf: transactions)
        let sTransactions: [SendableTransaction] = fkTransactions.map {
            $0.toSendableTransaction
        }
        return sTransactions
    }
}

extension FinanceKit.Transaction {
    @available(iOS 18, *)
    var toCarTransaction: Transaction {
        let isExpense: Bool = self.creditDebitIndicator == .debit
        var currency = self.transactionAmount.amount
        if let foreignAmount = self.foreignCurrencyAmount,
           let foreignExchangeRate = self.foreignCurrencyExchangeRate {
            currency = foreignAmount.amount * foreignExchangeRate
        }
        return Transaction(
            destination: .safeToSpend,
            category: .other,
            item: nil,
            fund: nil,
            amount: currency,
            type: isExpense ? .expense : .income,
            transactionDescription: self.transactionDescription,
            date: self.transactionDate)
    }
    
    @available(iOS 18, *)
    var toSendableTransaction: SendableTransaction {
        let isExpense: Bool = self.creditDebitIndicator == .debit
        var currency = self.transactionAmount.amount
        if let foreignAmount = self.foreignCurrencyAmount,
           let foreignExchangeRate = self.foreignCurrencyExchangeRate {
            currency = foreignAmount.amount * foreignExchangeRate
        }
        return SendableTransaction(
            date: self.transactionDate,
            description: self.transactionDescription,
            type: isExpense ? .expense : .income,
            amount: currency,
            category: self.merchantCategoryCode?.description)
    }
}
#endif
