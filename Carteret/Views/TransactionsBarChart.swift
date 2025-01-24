//
//  TransactionsBarChart.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/24/25.
//

import SwiftUI
import Charts

struct TransactionsBarChart: View {
    
    struct BarPlot: Identifiable {
        let id = UUID()
        let date: Date
        let amount: Currency
    }
    
    let xAxisName: String
    let yAxisName: String
    let data: [Transaction]
    
    var plottableData: [BarPlot] {
        return data.map { BarPlot(date: $0.date, amount: $0.currencyAmount) }
    }
    
    var body: some View {
        Chart(plottableData) { plot in
            BarMark(x: .value(xAxisName, plot.date, unit: .day),
                    y: .value(yAxisName, plot.amount))
        }
        .chartYAxis {
            AxisMarks(format: .currency(code: Locale.currencyCode))
        }
        .scaledToFit()
    }
}
