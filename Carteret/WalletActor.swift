//
//  WalletActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

import FinanceKit
import Foundation
import OSLog

@available(iOS 17.4, *)
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
    
    func requestAuthorizationSuccess() async -> Bool {
        do {
            return try await store.requestAuthorization() == .authorized
        } catch {
            return false
        }
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
