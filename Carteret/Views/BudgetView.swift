//
//  BudgetView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import Foundation
import SwiftUI
import SwiftData
import OSLog
import Charts
import RohrigSoftwareCompanyCore

struct BudgetView: View {
    
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "BudgetView")
    private let debugCategory = Category(name: "Debug")
    private let email = "me+carteret@alexanderrohrig.com"
    
    @EnvironmentObject private var budgetManager: BudgetManager
    @Environment(\.modelContext) private var modelContext
    @Query(filter: Item.activeItemsPredicate()) private var items: [Item]
    @Query private var funds: [Fund]
    @State private var showEditItem = false
    @State private var showUpgrade = false
    @State private var showMailMessage = false
    @State private var itemToEdit: Item?
    @State private var itemToShow: Item?
    @State private var fundToEdit: Fund?
    @State private var fundToShow: Fund?
    @AppStorage(Constant.prereleaseWarning) private var hidePrereleaseWarning = false
    
    var spendingLimit: Currency {
        // TODO: Income - bills - savings - funds
        let spendingLimit = incomeTotal - billsTotal - savingsTotal
        return spendingLimit
    }
    
    var incomeTotal: Currency {
        var total = Currency.zero
        for item in items where item.isIncome {
            total += item.weeklyAmount
        }
        return total
    }
    
    var billsTotal: Currency {
        var total = Currency.zero
        for item in items where item.isBill {
            total += item.weeklyAmount
        }
        return total
    }
    
    var savingsTotal: Currency {
        var total = Currency.zero
        for item in items where item.isSavings {
            total += item.weeklyAmount
        }
        return total
    }
    
    /// App version
    ///
    /// https://semver.org
    ///
    /// major.minor.patch-prerelease+build
    var appVersion: String { "\(RSCCore.shared.version)-A" }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if spendingLimit > 0 {
                        SpendingLimitRow(income: incomeTotal,
                                         bills: billsTotal,
                                         savings: savingsTotal,
                                         spendingLimit: spendingLimit)
                    }
                    
                    LabeledContent("Income", value: incomeTotal.display)
                    
                    LabeledContent("Bills", value: billsTotal.display)
                    
                    LabeledContent("Savings", value: savingsTotal.display)
                }
                
                Section("Recurring items") {
                    ForEach(items) { item in
                        itemRow(item)
                    }
                    
                    Button("Create a new item") {
                        itemToEdit = nil
                        showEditItem = true
                    }
                }
                
                Section("Funds") {
                    ForEach(funds) { fund in
                        NavigationLink(value: fund) {
                            Text(fund.fundDescription)
                        }
                    }
                    
                    Button("Create a new fund") {
                        fundToEdit = Fund()
                    }
                }
                
#if DEBUG
                Section("DEBUG") {
                    LabeledContent("Version", value: appVersion)
                    
                    Toggle("Hide pre-release warning", isOn: $hidePrereleaseWarning)
                    
                    Toggle("Show upgrade sheet", isOn: $showUpgrade)
                }
#endif
                
                Section {
                    Button("Send report") {
                        showMailMessage = true
                    }
                }
            }
            .onChange(of: incomeTotal) { _, newValue in
                if newValue > Constant.maxFreeWeeklyIncome {
                    // TODO: Show force subscription sheet
                    showUpgrade = true
                }
            }
            .sheet(isPresented: $showEditItem) {
                EditItemView(item: itemToEdit)
            }
            .sheet(item: $itemToEdit) { item in
                EditItemView(item: item)
            }
            .sheet(item: $itemToShow) { item in
                ItemVisuals(item: item)
            }
            .sheet(isPresented: $showUpgrade) {
                UpgradeView()
            }
            .sheet(item: $fundToEdit) { fund in
                EditFundView(fund: fund)
            }
            .sheet(isPresented: $showMailMessage) {
                // TODO: Add version and other to body
                MailComposeViewControllerRepresentable(toRecipients: [email],
                                                       subject: "Carteret report",
                                                       body: "TODO")
            }
            .navigationDestination(for: Fund.self) { fund in
                FundDetailView(fund: fund)
            }
            .task {
                budgetManager.spendingLimit = spendingLimit
            }
            .safeAreaInset(edge: .bottom) {
                if !hidePrereleaseWarning {
                    Text("""
                 You are using an alpha version (\(appVersion)) of Carteret.
                 Be advised data could disappear at any time.
                 This app is unstable and incomplete.
                 """)
                    .background(Color(uiColor: .systemBackground))
                }
            }
        }
    }
    
    @ViewBuilder
    func itemRow(_ item: Item) -> some View {
        HStack {
            Text(item.itemDescription)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(item.currencyAmount, format: .currency(code: Locale.currencyCode))
                    .foregroundStyle(color(for: item.type))
                
                Text(item.itemRepeat.displayName)
                    .font(.caption)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Details") {
                itemToEdit = item
            }
            
            if !item.transactions.isEmpty {
                Button("Visuals") {
                    itemToShow = item
                }
                .tint(Color.blue)
            }
        }
    }
    
    func color(for transactionType: TransactionType) -> Color {
        switch transactionType {
        case .income:
            Color.green
        case .expense:
            Color.red
        }
    }
}
