//
//  PieChart.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import SwiftUI
import Charts

struct PieChart: View {
    struct PieChartSegment: Identifiable {
        static let previewData: [PieChartSegment] = [
            .init(name: "Eating out", amount: 6.69),
            .init(name: "Entertainment", amount: 185.00),
            .init(name: "Gas", amount: 24.13),
            .init(name: "Groceries", amount: 0.00),
            .init(name: "Other", amount: 185.00),
            .init(name: "Shopping", amount: 0.00),
        ]
        
        let id = UUID()
        let name: String
        let amount: Decimal
    }
    
    let data: [PieChartSegment]
    
    var body: some View {
        Chart(PieChartSegment.previewData) { segment in
            SectorMark(angle: .value("Amount", segment.amount))
                .foregroundStyle(by: .value("Category", segment.name))
        }
        .scaledToFit()
    }
}

#Preview {
    PieChart(data: PieChart.PieChartSegment.previewData)
}
