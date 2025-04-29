//
//  PlaidCreateLinkTokenRequest.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

struct PlaidCreateLinkTokenRequest: Codable {
    static let english = "en"
    static let unitedStates = ["US"]
    static let transactions = ["transactions"]
    
    struct User: Codable {
        let client_user_id: String
    }
    
    let client_id: String
    let secret: String
    let client_name: String
    let language: String
    let country_codes: [String]
    let user: User
    let redirect_uri: String
    let products: [String]
}
