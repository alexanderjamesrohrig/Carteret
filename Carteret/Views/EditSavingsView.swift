//
//  EditSavingsView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/13/25.
//

import SwiftUI
import OSLog

struct EditSavingsView: View {
    private let logger = Logger(subsystem: Constant.subsystem, category: "EditSavingsView")
    @Environment(\.dismiss) private var dismiss
    @Binding var savingsData: Data
    @State private var selectedType: Savings.SavingsType = .percentage
    @State private var selectedAmount: String = "0"
    @State private var animateSelectedAmount: CGFloat = 0
    
    var selectedAmountNumber: Double {
        let fromFormatter = NumberFormatter()
        fromFormatter.numberStyle = .decimal
        let nsNumber = fromFormatter.number(from: selectedAmount) ?? 0
        return Double(truncating: nsNumber)
    }
    
    var formattedSelectedAmount: String {
        switch selectedType {
        case .percentage:
            let fromFormatter = NumberFormatter()
            fromFormatter.numberStyle = .decimal
            let numberString = fromFormatter.number(from: selectedAmount) ?? 0
            let toFormatter = NumberFormatter()
            toFormatter.numberStyle = .percent
            return toFormatter.string(from: numberString) ?? "Invalid"
        case .currencyAmount:
            return Decimal(string: selectedAmount)?.display ?? "Invalid"
        }
    }
    
    var body: some View {
        VStack {
            Text("Update savings rate")
                .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                .padding(25)
            
            VStack(alignment: .center) {
                Text(selectedAmount)
                    .font(.system(.largeTitle, design: .monospaced, weight: .regular))
                    .padding(.vertical)
                    .modifier(HorizontalShakeAnimation(animatableData: animateSelectedAmount))
                
                Spacer()
                
                VStack {
                    Picker("Save percent or specific amount of spending limit ", selection: $selectedType) {
                        Text("Percent")
                            .tag(Savings.SavingsType.percentage)
                        
                        Text("Specific amount")
                            .tag(Savings.SavingsType.currencyAmount)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("of spending limit")
                        .font(.footnote)
                }
                .padding(25)
                
                inViewNumberPad
                
                bottomButtons
            }
        }
        .onAppear {
            selectedAmount = "\(Savings.from(data: savingsData).amount)"
        }
    }
    
    @ViewBuilder var bottomButtons: some View {
        HStack(alignment: .center) {
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            Button("Update") {
                let data = Savings(
                    amount: decimal(from: selectedAmount),
                    type: selectedType).toData
                savingsData = data
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(25)
    }
    
    @ViewBuilder var inViewNumberPad: some View {
        Grid {
            GridRow {
                numberPadKeyButton("1")
                
                numberPadKeyButton("2")
                
                numberPadKeyButton("3")
            }
            
            GridRow {
                numberPadKeyButton("4")
                
                numberPadKeyButton("5")
                
                numberPadKeyButton("6")
            }
            
            GridRow {
                numberPadKeyButton("7")
                
                numberPadKeyButton("8")
                
                numberPadKeyButton("9")
            }
            
            GridRow {
                numberPadKeyButton(".")
                
                numberPadKeyButton("0")
                
                Button {
                    if selectedAmount == "0" {
                        return
                    } else if selectedAmount.count == 1 {
                        selectedAmount = "0"
                    } else {
                        selectedAmount.removeLast()
                    }
                } label: {
                    Image(systemName: "delete.backward")
                        .padding(10)
                        .font(.system(.title, design: .monospaced, weight: .medium))
                }
                .buttonBorderShape(.circle)
                .buttonStyle(.bordered)
            }
        }
    }
    
    @ViewBuilder func numberPadKeyButton(_ label: String) -> some View {
        Button {
            addNumber(label)
        } label: {
            Text(label)
                .padding(10)
                .font(.system(.largeTitle, design: .monospaced, weight: .medium))
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
    }
    
    func addNumber(_ string: String) {
        if selectedAmount == "0" {
            selectedAmount = string
        } else if selectedAmount.count > 8 && selectedType == .currencyAmount {
            withAnimation {
                animateSelectedAmount += 1
            }
            return
        } else {
            selectedAmount += string
        }
    }
    
    func decimal(from: String) -> Decimal {
        do {
            return try Decimal(from, format: .number)
        } catch {
            logger.error("Error converting String to Decimal")
            return 0.0
        }
    }
}

enum InViewNumberPadKey {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case decimal
    case zero
    case delete
}

struct HorizontalShakeAnimation: GeometryEffect {
    var amount: CGFloat = 10
    var shakes: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let sin = sin(animatableData * .pi * shakes)
        let xTranslation = amount * sin
        let transform = CGAffineTransform(translationX: xTranslation, y: 0)
        return ProjectionTransform(transform)
    }
}

#Preview {
    EditSavingsView(savingsData: .constant(Savings.empty.toData))
}
