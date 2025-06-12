//
//  ConnectWalletButton.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/12/25.
//

import SwiftUI
import FinanceKit
import FinanceKitUI

@available(iOS 18, *)
struct ConnectWalletButton: View {
    @State private var selectedTransactions: [FinanceKit.Transaction] = []
    
    var body: some View {
        if FinanceStore.isDataAvailable(.financialData) {
            TransactionPicker(selection: $selectedTransactions) {
                Text("Show Transaction Picker")
            }
        }
    }
}
