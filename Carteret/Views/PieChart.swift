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
            .init(name: "Eating out", amount: 6.69, color: .black),
            .init(name: "Entertainment", amount: 185.00, color: .blue),
            .init(name: "Gas", amount: 24.13, color: .gray),
            .init(name: "Groceries", amount: 0.00, color: .green),
            .init(name: "Other", amount: 185.00, color: .brown),
            .init(name: "Shopping", amount: 0.00, color: .cyan),
        ]
        
        let id = UUID()
        let name: String
        let amount: Decimal
        let color: Color
    }
    
    let data: [PieChartSegment]
    
    var body: some View {
        Chart(data) { segment in
            SectorMark(angle: .value("Amount", segment.amount))
                .foregroundStyle(by: .value("Category", segment.name))
        }
        .scaledToFit()
    }
}

#Preview {
    PieChart(data: PieChart.PieChartSegment.previewData)
}
