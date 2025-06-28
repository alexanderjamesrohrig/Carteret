//
//  ChartHelper.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/27/25.
//

enum ChartHelper {
    static func pieChartSegments(
        from transactions: [Transaction]
    ) -> [PieChart.PieChartSegment] {
        var combinedDict: [TransactionCategory: Currency] = [:]
        for transaction in transactions {
            if let category = transaction.category {
                combinedDict[category, default: 0.0] += transaction.currencyAmount
            }
        }
        let segments: [PieChart.PieChartSegment] = combinedDict.map {
            PieChart.PieChartSegment(
                name: $0.key.displayName,
                amount: $0.value,
                color: $0.key.displayColor)
        }
        return segments
    }
}
