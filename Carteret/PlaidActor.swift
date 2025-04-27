//
//  PlaidActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/26/25.
//

import Foundation
import LinkKit
import LinkKitSub
import LinkPresentation
import OSLog

actor PlaidActor {
    enum PlaidError: Error {
        case linkConfigurationFailure
    }
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "PlaidActor")
    private let sandboxUsername = "user_good"
    private let sandboxTransactionUsername = "user_transactions_dynamic"
    private let sandboxPassword = "pass_good"
    
    private var linkToken = ""
    var publicToken = ""
    
    private var linkTokenConfiguration: LinkTokenConfiguration {
        var configuration = LinkTokenConfiguration(token: linkToken) { linkSuccess in
            self.linkSuccess(linkSuccess: linkSuccess)
        }
        configuration.onExit = linkExit
        configuration.onEvent = linkEvent
        return configuration
    }
    
    var handler: Handler {
        get throws {
            let configuration = linkTokenConfiguration
            let result = Plaid.create(configuration)
            switch result {
            case .failure(let error):
                logger.error("Creation failure :- \(error.localizedDescription)")
                throw PlaidError.linkConfigurationFailure
            case .success(let handler):
                return handler
            }
        }
    }
    
    private func linkSuccess(linkSuccess: LinkSuccess) {
        publicToken = linkSuccess.publicToken // TODO: Save to defaults
        let accountCount = linkSuccess.metadata.accounts.count
        let institution = linkSuccess.metadata.institution.name
        logger.info("Linked \(accountCount) \(institution) accounts")
    }
    
    private func linkExit(linkExit: LinkExit) {
        if let message = linkExit.error?.errorMessage {
            logger.error("\(message)")
        }
        logger.info("Exited during \(linkExit.metadata.status.debugDescription)")
    }
    
    private func linkEvent(linkEvent: LinkEvent) {
        logger.info("\(linkEvent.eventName.description)")
    }
}
