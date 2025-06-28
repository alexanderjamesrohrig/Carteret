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
        let sorted = safeToSpendOnly.sorted {
            assert($0.category != nil)
            assert($1.category != nil)
            if let firstCategory = $0.category,
               let secondCategory = $1.category {
                return firstCategory < secondCategory
            }
            return false
        }
        self.barData = safeToSpendOnly.map { transaction in
                .init(date: transaction.date,
                      amount: transaction.currencyAmount,
                      category: transaction.category!)
        }
    }
    
    let transactions: [Transaction]
    let barData: [BarPlot]
    
    var body: some View {
        Form {
            Section("Safe-to-spend") {
                VStack {
                    PieChart(data: ChartHelper.pieChartSegments(from: transactions))
                }
            }
            
            Section("Daily") {
                VStack {
                    Chart(barData) { plot in
                        BarMark(x: .value("Date", plot.date, unit: .day),
                                y: .value("Amount", plot.amount))
                        .foregroundStyle(plot.category.displayColor)
                    }
                    .chartXAxis {
                        AxisMarks(format: MonthDayFormat())
                    }
                    .chartYAxis {
                        AxisMarks(format: .currency(code: Locale.currencyCode))
                    }
                    .scaledToFit()
                    
                    legend
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder var legend: some View {
        Grid {
            GridRow {
                transactionLegendItem(category: .eatingOut)
                
                transactionLegendItem(category: .entertainment)
                
                transactionLegendItem(category: .gas)
            }
            
            GridRow {
                transactionLegendItem(category: .groceries)
                
                transactionLegendItem(category: .shopping)
                
                transactionLegendItem(category: .other)
            }
        }
    }
    
    @ViewBuilder func transactionLegendItem(category: TransactionCategory) -> some View {
        HStack {
            Circle()
                .foregroundStyle(category.displayColor)
                .frame(width: 5, height: 5)
            
            Text(category.displayName)
                .font(.caption)
        }
    }
}

#Preview {
    let previewData: [Transaction] = [
        Transaction(
            destination: .safeToSpend,
            category: .eatingOut,
            item: nil,
            fund: nil,
            amount: 45.00,
            type: .expense,
            transactionDescription: "Eating out",
            date: Date.now
        ),
        Transaction(
            destination: .safeToSpend,
            category: .entertainment,
            item: nil,
            fund: nil,
            amount: 30.00,
            type: .expense,
            transactionDescription: "Alamo drafthouse`",
            date: Date.now
        )
    ]
    WeekVisuals(transactions: previewData)
}
