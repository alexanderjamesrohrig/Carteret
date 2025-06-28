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
    private let cloud = CloudKitActor()
    
    @EnvironmentObject private var storeroom: Storeroom
    
    @State private var plaidAPIStatus = "Unknown"
    @State private var akoyaAPIStatus = "Unknown"
    @State private var walletAvailable = "Unknown"
    @State private var walletAuthorization = "Unknown"
    @State private var showLinkView = false
    @State private var walletAccountsCount = 0
    @State private var iCloudDriveAvailable = "Unknown"
    @State private var yearlySubscription = "Unknown"
    @State private var inAppPurchases = "Unknown"
    
    var body: some View {
        Form {
            Section("Plaid") {
                LabeledContent("API status", value: plaidAPIStatus)
            }
            
            Section("Akoya") {
                LabeledContent("API status", value: akoyaAPIStatus)
            }
            
            Section("FinanceKit") {
                LabeledContent("Available", value: walletAvailable)
                
                LabeledContent("Authorized", value: walletAuthorization)
                
                LabeledContent("Accounts", value: "\(walletAccountsCount)")
            }
            
            Section("CloudKit") {
                LabeledContent("iCloud Drive", value: iCloudDriveAvailable)
            }
            
            Section("Subscription") {
                LabeledContent("In app purchases", value: inAppPurchases)
                
                LabeledContent("Yearly subscription", value: yearlySubscription)
            }
        }
        .fullScreenCover(isPresented: $showLinkView) {}
        .task {
            plaidAPIStatus = await plaid.apiStatus
            walletAvailable = wallet.isAvailable ? "Yes" : "No"
            walletAuthorization = await wallet.authorized ? "Yes" : "No"
            walletAccountsCount = await wallet.accounts().count
            iCloudDriveAvailable = await cloud.iCloudDriveAvailable.display
            yearlySubscription = storeroom.hasSubscription(.yearSubscription).display
            inAppPurchases = storeroom.purchasesAvailable.display
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
