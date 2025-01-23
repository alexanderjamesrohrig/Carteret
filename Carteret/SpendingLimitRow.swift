//
//  SpendingLimitRow.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import SwiftUI

struct SpendingLimitRow: View {
    let income: Decimal
    let bills: Decimal
    let savings: Decimal
    let spendingLimit: Decimal
    let spendingLimitText = "Spending limit"
    
    var billsPercentage: Double {
        (bills / income).toDouble
    }
    
    var savingsPercentage: Double {
        (savings / income).toDouble
    }
    
    var spendingLimitPercentage: Double {
        (spendingLimit / income).toDouble
    }
    
    var chartData: [BarChart1D.Category] {
        [
            BarChart1D.Category(percentage: billsPercentage, name: "Bills"),
            BarChart1D.Category(percentage: savingsPercentage, name: "Savings"),
            BarChart1D.Category(percentage: spendingLimitPercentage,
                                name: spendingLimitText),
        ]
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(spendingLimitText)
                
                Spacer()
                
                Text(spendingLimit, format: .currency(code: Locale.currencyCode))
                    .foregroundStyle(Color.secondary)
            }
            
            BarChart1D(data: chartData)
                .frame(height: 50)
        }
    }
}

#Preview {
    List {
        SpendingLimitRow(income: 100,
                         bills: 30,
                         savings: 20,
                         spendingLimit: 50)
        
        LabeledContent("Spending limit", value: "89.27")
    }
}
