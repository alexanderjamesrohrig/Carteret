//
//  BarChart1D.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import SwiftUI
import Charts

struct BarChart1D: View {
    struct Category: Identifiable {
        static let previewData: [Category] = [
            Category(percentage: 59.0, name: "Bills"),
            Category(percentage: 20.0, name: "Savings"),
            Category(percentage: 21.0, name: "Spending limit"),
        ]
        
        let id = UUID()
        let percentage: Double
        let name: String
    }


    let data: [Category]
    
    var maxXValue: Double {
        data.map { $0.percentage }.reduce(0, +)
    }
    
    var body: some View {
        Chart(data) {
            BarMark(x: .value("Percentage", $0.percentage))
                .foregroundStyle(by: .value("Category", $0.name))
        }
        .chartXScale(domain: 0...maxXValue)
        .chartXAxis(.hidden)
    }
}

#Preview {
    BarChart1D(data: BarChart1D.Category.previewData)
}
