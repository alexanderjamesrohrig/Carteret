//
//  PlaidActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/26/25.
//

#if canImport(LinkKit)
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
    private let sandboxHost = "https://sandbox.plaid.com"
    private let productionHost = "https://production.plaid.com"
    private let createLinkTokenPath = "/link/token/create"
    private let statusURL = "https://status.plaid.com/api/v2/status.json"
    
    private(set) var publicToken = ""
    
    var linkToken: String? {
        get async {
            guard let url = URL(string: "\(sandboxHost)\(createLinkTokenPath)") else {
                return nil
            }
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            let id = UUID().uuidString
            let user = PlaidCreateLinkTokenRequest.User(client_user_id: id)
            let requestBody = PlaidCreateLinkTokenRequest(
                client_id: "680d02c8adebe6002487673b",
                secret: "", // FIXME: Do not hardcode
                client_name: "Carteret",
                language: PlaidCreateLinkTokenRequest.english,
                country_codes: PlaidCreateLinkTokenRequest.unitedStates,
                user: user,
                redirect_uri: "https://www.alexanderrohrig.com/plaid",
                products: PlaidCreateLinkTokenRequest.transactions
            )
            do {
                let requestBodyJSON = try encoder.encode(requestBody)
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = requestBodyJSON
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoded = try decoder.decode(PlaidCreateLinkTokenResponse.self,
                                                 from: data)
                return decoded.request_id
            } catch {
                logger.error("Link :- \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    var handler: Handler {
        get async throws {
            guard let configuration = await linkTokenConfiguration else {
                throw PlaidError.linkConfigurationFailure
            }
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
    
    var apiStatus: String {
        get async {
            let decoder = JSONDecoder()
            guard let url = URL(string: statusURL),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let decoded = try? decoder.decode(PlaidStatusResponse.self, from: data) else {
                return "nil"
            }
            return decoded.status.description
        }
    }
    
    private var linkTokenConfiguration: LinkTokenConfiguration? {
        get async {
            guard let linkToken = await linkToken else { return nil }
            var configuration = LinkTokenConfiguration(token: linkToken) { linkSuccess in
                self.linkSuccess(linkSuccess: linkSuccess)
            }
            configuration.onExit = linkExit
            configuration.onEvent = linkEvent
            return configuration
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
#endif
