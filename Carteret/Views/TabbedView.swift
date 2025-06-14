//
//  TabbedView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import SwiftUI

struct TabbedView: View {
    
    @StateObject private var budgetManager = BudgetManager()
    @StateObject private var debugSettings = DebugSettings()
    @State private var selectedTab: Tab = .budget
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: CarteretImage.budgetTabName)
                }
                .tag(Tab.budget)
            
            WeekView()
                .tabItem {
                    Label("This week", systemImage: CarteretImage.thisWeekTabName)
                }
                .tag(Tab.week)
        }
        .environmentObject(budgetManager)
        .environmentObject(debugSettings)
    }
}
