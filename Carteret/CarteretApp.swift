//
//  CarteretApp.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import SwiftUI
import SwiftData

public typealias Currency = Decimal

/*
 TODO: New transaction control
 */

@main
struct CarteretApp: App {
    @StateObject private var storeroom = Storeroom()
    @Environment(\.scenePhase) private var scenePhase
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Loan.self,
            Payment.self,
            Transaction.self,
            Fund.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabbedView()
                .environmentObject(storeroom)
                .task(id: scenePhase) {
                    await storeroom.setActiveTransactions()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
