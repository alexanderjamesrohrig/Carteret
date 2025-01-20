//
//  CurrencyField.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import SwiftUI

struct CurrencyField: View {
    
    let currencyCode = Locale.current.currency?.identifier ?? ""
    let title: String
    
    @Binding var amount: Double
//    @Binding var focusedField: InputField?
    
    var body: some View {
        TextField(title, value: $amount, format: .currency(code: currencyCode))
//            .keyboardType(.decimalPad)
//            .focused($focusedField, equals: InputField.amount)
    }
}
