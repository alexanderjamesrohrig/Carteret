//
//  AkoyaActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/27/25.
//

import Foundation
import AuthenticationServices
import OSLog

@available(iOS 17.4, *)
actor AkoyaActor {
    enum AkoyaError: Error {
        case badURL, sessionFailure
    }
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "AkoyaActor")
    private let callbackURL = "https://recipient.ddp.akoya.com/flow/callback"
    private let clientID = "03acc008-a4fb-4a11-9234-952f9ba38d9c"
    private let secret = "guoixJlqHFhRyVCNoaz~sDYFB3"
    private let authURL = "https://sandbox-idp.ddp.akoya.com/auth"
    private let authHost = "recipient.ddp.akoya.com"
    private let authPath = "/flow/callback"
    private let authHelper = AuthHelper()
    
    func authenticate() async throws -> URL {
        guard let url = URL(string: authURL) else {
            throw AkoyaError.badURL
        }
        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(
                url: url,
                callback: .https(host: authHost, path: authPath)) { url, error in
                    if let error {
                        self.logger.error("\(error.localizedDescription)")
                        continuation.resume(throwing: AkoyaError.sessionFailure)
                    } else if let url {
                        continuation.resume(returning: url)
                    }
                }
            session.presentationContextProvider = authHelper
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
    }
}
