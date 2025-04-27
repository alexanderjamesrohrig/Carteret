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
        Button("Connect Plaid") {
            showPlaid = true
        }
        .fullScreenCover(isPresented: $showPlaid) {
            if let handler {
                PlaidLinkView(handler: handler)
                    .ignoresSafeArea()
            } else {
                ContentUnavailableView("Plaid is unavailable",
                                       systemImage: "network.slash")
            }
        }
    }
    
    func createHandler() -> Handler? {
        return nil
    }
}
