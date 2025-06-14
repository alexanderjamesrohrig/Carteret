//
//  EditSavingsView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/13/25.
//

import SwiftUI

struct EditSavingsView: View {
    
    @Binding var savingsData: Data
    @State private var selectedType: Savings.SavingsType = .percentage
    @State private var selectedPercentage: Decimal = .zero
    @State private var selectedCurrencyAmount: Currency = .zero
    
    var amountText: String {
        switch selectedType {
        case .percentage:
            let nsNumber = selectedCurrencyAmount as NSNumber
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            return formatter.string(from: nsNumber) ?? "Invalid"
        case .currencyAmount:
            return selectedCurrencyAmount.display
        }
    }
    
    var savings: Binding<Savings> {
        Binding {
            return Savings.from(data: savingsData)
        } set: { newSavings in
            savingsData = newSavings.toData
        }
    }
    
    var body: some View {
        VStack {
            Text("Update savings rate")
            
            VStack(alignment: .center) {
                Text(amountText)
                
                
            }
        }
    }
}

#Preview {
    EditSavingsView(savingsData: .constant(Savings.empty.toData))
}
