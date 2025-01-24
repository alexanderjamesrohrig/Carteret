//
//  ItemVisuals.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/24/25.
//

import SwiftUI

struct ItemVisuals: View {
    
    let item: Item
    
    var body: some View {
        Form {
            TransactionsBarChart(xAxisName: "Date",
                                 yAxisName: "Amount",
                                 data: item.transactions)
        }
        .presentationDragIndicator(.visible)
    }
}
