//
//  PlaidCreateLinkTokenResponse.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

struct PlaidCreateLinkTokenResponse: Codable {
    let link_token: String
    let expiration: String
    let request_id: String
}
