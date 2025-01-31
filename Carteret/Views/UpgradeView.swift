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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Making over $100,000 a year?")
                .font(.title)
            
            Text("You can afford to pay for a subscription.")
                .foregroundStyle(.secondary)
            
            Text("One month free, then only $1 a year.")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Button("Try One Month Free") {
                // TODO: Buy subscription
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
    }
}

#Preview {
    UpgradeView()
}
