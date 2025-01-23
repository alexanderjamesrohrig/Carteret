//
//  CurrencyText.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/23/25.
//

import SwiftUI

struct CurrencyText: View {
    let amount: Currency
    
    var body: some View {
        Text(amount, format: .currency(code: Locale.currencyCode))
    }
}
