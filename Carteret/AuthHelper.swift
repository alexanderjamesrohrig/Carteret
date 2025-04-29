//
//  AuthHelper.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/27/25.
//

import Foundation
import AuthenticationServices
import OSLog

@available(iOS 17.4, *)
class AuthHelper: NSObject, ObservableObject {
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "AuthHelper")
    func authenticate() {
        guard let url = URL(string: "https://sandbox-idp.ddp.akoya.com/auth") else {
            return
        }
        let session = ASWebAuthenticationSession(
            url: url,
            callback: .https(host: "recipient.ddp.akoya.com",
                             path: "/flow/callback")) { url, error in
                self.logger.info("\(url?.absoluteString ?? "url")")
                if let error {
                    self.logger.error("\(error.localizedDescription)")
                }
            }
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
}

@available(iOS 17.4, *)
extension AuthHelper: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
