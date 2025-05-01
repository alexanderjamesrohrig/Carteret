//
//  UpgradeView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/25.
//

import SwiftUI
import StoreKit
import OSLog

struct UpgradeView: View {
    
    let logger = Logger(subsystem: Constant.carteretSubsystem, category: "UpgradeView")
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var storeroom: Storeroom
    @State private var subscription: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Making over $100,000 a year?")
                .font(.title)
            
            Text("You can afford to pay for a subscription.")
                .foregroundStyle(.secondary)
            
            if let subscription {
                Text("One month free, then only \(subscription.displayPrice) a year.")
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button("Try One Month Free") {
                assert(subscription != nil)
                Task {
                    if let subscription {
                        try await storeroom.purchase(product: subscription)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            
            Button("No, I'm Poor") {
                dismiss()
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
        }
        .padding()
        .presentationDetents([.medium])
        .interactiveDismissDisabled()
        .task {
            if await storeroom.inventory.isEmpty {
                dismiss()
            } else {
                subscription = await storeroom.inventory.first
            }
        }
    }
}

#Preview {
    UpgradeView()
}
