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
        VStack {
            if storeroom.hasSubscription(.yearSubscription) {
                thankYou
            } else {
                purchaseProduct
            }
        }
        .padding()
        .presentationDetents([.medium])
        .task {
            if await storeroom.inventory.isEmpty {
                dismiss()
            } else {
                subscription = await storeroom.inventory.first
            }
        }
    }
    
    @ViewBuilder var thankYou: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.green)
                .font(.system(.largeTitle, design: .default, weight: .heavy))
            
            Text("Thank you for being a subscriber.")
        }
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder var purchaseProduct: some View {
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
            
            Button("Try one month free") {
                assert(subscription != nil)
                Task {
                    if let subscription {
                        let purchased = try await storeroom.purchase(product: subscription)
                        if purchased {
                            dismiss()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            
            Button("No, I'm poor") {
                dismiss()
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .buttonStyle(.bordered)
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    UpgradeView()
}
