//
//  TestView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/29/25.
//

import SwiftUI
#if canImport(LinkKit)
@preconcurrency import LinkKit

@available(iOS 17.4, *)
struct TestView: View {
    
    private let authHelper = AuthHelper()
    private let akoya = AkoyaActor()
    private let plaid = PlaidActor()
    private let wallet = WalletActor()
    
    @State private var plaidAPIStatus = "Unknown"
    @State private var walletAvailable = "Unknown"
    @State private var walletAuthorization = "Unknown"
    @State private var showLinkView = false
    
    var body: some View {
        Form {
            Section("Plaid") {
                LabeledContent("API status", value: plaidAPIStatus)
            }
            
            Section("Akoya") {
                LabeledContent("API status", value: "TBD")
            }
            
            Section("FinanceKit") {
                LabeledContent("Available", value: walletAvailable)
                
                LabeledContent("Authorized", value: walletAuthorization)
            }
        }
        .fullScreenCover(isPresented: $showLinkView) {}
        .task {
            plaidAPIStatus = await plaid.apiStatus
            walletAvailable = wallet.isAvailable ? "Yes" : "No"
            walletAuthorization = await wallet.authorized ? "Yes" : "No"
        }
    }
}
#else
struct TestView: View {
    var body: some View {
        Form {
            Text("macOS")
        }
    }
}
#endif
