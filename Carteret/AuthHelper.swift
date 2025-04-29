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
    enum Service {
        case akoya, plaid
        
        var authURL: String {
            switch self {
            case .akoya: "https://sandbox-idp.ddp.akoya.com/auth"
            case .plaid: ""
            }
        }
        
        var callbackPath: String {
            switch self {
            case .akoya: "akoya/flow/callback"
            case .plaid: "plaid"
            }
        }
    }
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "AuthHelper")
    
    var session: ASWebAuthenticationSession?
    
    func authenticate(service: Service) {
        
        guard let url = URL(string: service.authURL) else {
            return
        }
        session = ASWebAuthenticationSession(
            url: url,
            callback: .https(host: "www.alexanderrohrig.com",
                             path: service.callbackPath)) { url, error in
                self.logger.info("URL :- \(url?.absoluteString ?? "nil")")
                if let error {
                    self.logger.error("\(error.localizedDescription)")
                }
            }
        assert(session != nil)
        guard let session else { return }
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
