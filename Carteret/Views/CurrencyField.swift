//
//  CurrencyField.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import SwiftUI

struct CurrencyField: View {
    
    @Binding var amount: Currency?
    @FocusState.Binding var focusedField: InputField?
    
    var title: String {
        var title = "Amount"
        if let currencyName = Locale.autoupdatingCurrent.currencySymbol {
            title += " (\(currencyName))"
        }
        return title
    }
    
    var body: some View {
        TextField(title, value: $amount, format: .currency(code: Locale.currencyCode))
            .keyboardType(.decimalPad)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
            .focused($focusedField, equals: InputField.amount)
    }
}
