//
//  CarteretApp.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import SwiftUI
import SwiftData

public typealias Currency = Decimal

@main
struct CarteretApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Loan.self,
            Payment.self,
            Transaction.self,
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
        }
        .modelContainer(sharedModelContainer)
    }
}
