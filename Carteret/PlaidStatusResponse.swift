//
//  PlaidStatusResponse.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

struct PlaidStatusResponse: Decodable {
    struct PLPage: Decodable {
        let id: String
        let name: String
        let updated_at: String
    }
    
    struct PLStatus: Decodable {
        let indicator: String
        let description: String
    }
    
    let page: PLPage
    let status: PLStatus
}
