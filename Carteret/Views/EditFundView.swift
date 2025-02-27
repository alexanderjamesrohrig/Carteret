//
//  EditFundView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 2/27/25.
//

import SwiftUI
import OSLog

struct EditFundView: View {
    
    let fund: Fund
    let logger = Logger(subsystem: Constant.carteretSubsystem, category: "EditFundView")
    
    @State private var newDescription = ""
    @State private var newGoalAmount: Currency? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: InputField?
    
    var title: String {
        if fund.fundDescription.isEmpty {
            return "Create Fund"
        } else {
            return "Edit Fund"
        }
    }
    
    var confirmButtonTitle: String {
        if fund.fundDescription.isEmpty {
            return "Create"
        } else {
            return "Save"
        }
    }
    
    var saveDisabled: Bool {
        guard let newGoalAmount else { return true }
        return newDescription.isEmpty || newGoalAmount <= Currency.zero
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Description", text: $newDescription)
                        .focused($focusedField, equals: .description)
                        .textInputAutocapitalization(.sentences)
                        .onSubmit {
                            focusedField = .amount
                        }
                    
                    CurrencyField(amount: $newGoalAmount, focusedField: $focusedField)
                } footer: {
                    Text("Enter how much you want to save in the amount field.")
                }
            }
            .onAppear {
                focusedField = .description
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(confirmButtonTitle) {
                        save(fund)
                    }
                    .disabled(saveDisabled)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }
    
    func save(_ fund: Fund) {
        guard let newGoalAmount else { return }
        fund.fundDescription = newDescription
        fund.goalAmount = newGoalAmount
        modelContext.insert(fund)
        withAnimation {
            do {
                try modelContext.save()
                dismiss()
            } catch {
                logger.error("Cannot save fund changes")
            }
        }
    }
}
