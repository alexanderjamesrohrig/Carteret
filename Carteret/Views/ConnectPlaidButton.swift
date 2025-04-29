//
//  ConnectPlaidButton.swift
//  Carteret
//
//  Created by Alexander Rohrig on 4/26/25.
//

import SwiftUI
@preconcurrency import LinkKit

struct ConnectPlaidButton: View {
    init() {
        self.handler = createHandler()
    }
    
    private var handler: Handler?
    
    @State private var showPlaid = false
    
    var body: some View {
        Button("Connect to Plaid") {
            showPlaid = true
        }
        .fullScreenCover(isPresented: $showPlaid) {
            if let handler {
                PlaidLinkView(handler: handler)
                    .ignoresSafeArea()
            } else {
                VStack {
                    ContentUnavailableView("Plaid is unavailable",
                                           systemImage: "network.slash")
                    
                    Button("Close") {
                        showPlaid = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
    
    func createHandler() -> Handler? {
        return nil
    }
}
