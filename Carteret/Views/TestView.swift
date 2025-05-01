//
//  TestView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

import SwiftUI
@preconcurrency import LinkKit

@available(iOS 17.4, *)
struct TestView: View {
    
    private let authHelper = AuthHelper()
    private let akoya = AkoyaActor()
    private let plaid = PlaidActor()
    private let wallet = WalletActor()
    
    @State private var plaidAPIStatus = "Unknown"
    @State private var walletAuthorization = "false"
    @State private var showLinkView = false
    
    var body: some View {
        Form {
            Section("Plaid") {
                LabeledContent("API status", value: plaidAPIStatus)
            }
            
            Section("Akoya") {
                
            }
            
            Section("FinanceKit") {
                LabeledContent("Authorization", value: walletAuthorization)
            }
        }
        .fullScreenCover(isPresented: $showLinkView) {}
        .task {
            plaidAPIStatus = await plaid.apiStatus
            // TODO: Uncomment after entitled :- walletAuthorization = await wallet.authorized.description
        }
    }
}
