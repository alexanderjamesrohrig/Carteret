//
//  WeekVisuals.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import SwiftUI
import Charts

struct WeekVisuals: View {
    
    struct BarPlot: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Currency
        let category: TransactionCategory
    }
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
        let safeToSpendOnly = transactions.filter { $0.category != nil }
        // FIXME: Force unwrap
        let sorted = safeToSpendOnly.sorted { $0.category! < $1.category! }
        self.pieData = sorted.map { transaction in
                .init(name: transaction.category?.displayName ?? "nil",
                      amount: transaction.currencyAmount)
        }
        self.barData = safeToSpendOnly.map { transaction in
                .init(date: transaction.date,
                      amount: transaction.currencyAmount,
                      category: transaction.category!)
        }
    }
    
    let transactions: [Transaction]
    let pieData: [PieChart.PieChartSegment]
    let barData: [BarPlot]
    
    var body: some View {
        Form {
            Section("Safe-to-spend") {
                PieChart(data: pieData)
            }
            
            Section("Daily") {
                Chart(barData) { plot in
                    BarMark(x: .value("Date", plot.date, unit: .day),
                            y: .value("Amount", plot.amount))
                    .foregroundStyle(by: .value("Category", plot.category.displayName))
                }
                .scaledToFit()
            }
        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    let previewData: [Transaction] = [
        Transaction(
            destination: .safeToSpend,
            category: .eatingOut,
            item: nil,
            amount: 45.00,
            type: .expense,
            transactionDescription: "Eating out",
            date: Date.now
        ),
        Transaction(
            destination: .safeToSpend,
            category: .entertainment,
            item: nil,
            amount: 30.00,
            type: .expense,
            transactionDescription: "Alamo drafthouse`",
            date: Date.now
        )
    ]
    WeekVisuals(transactions: previewData)
}
