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
    
    var body: some View {
        TabView {
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: CarteretImage.budgetTabName)
                }
            
            WeekView()
                .tabItem {
                    Label("This week", systemImage: CarteretImage.thisWeekTabName)
                }
        }
        .environmentObject(budgetManager)
    }
}
