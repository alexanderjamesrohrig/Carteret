//
//  EditTransactionView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import SwiftUI
import SwiftData
import Foundation
import OSLog

struct EditTransactionView: View {
    let logger = Logger(subsystem: Constant.carteretSubsystem,
                        category: "EditTransactionView")
    let currencyCode = Locale.current.currency?.identifier ?? ""
    let transaction: Transaction?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var items: [Item]
    @FocusState private var focusedField: InputField?
    @State private var destination: TransactionDestination?
    @State private var transactionCategory: TransactionCategory?
    @State private var recurringItem: Item?
    @State private var description: String = ""
    @State private var amount: Double = 0.00
    @State private var type: TransactionType = .expense
    @State private var date = Date.now
    
    var title: String {
        transaction == nil ? "Create transaction" : "Edit transaction"
    }
    
    var confirmButtonTitle: String {
        transaction == nil ? "Create" : "Save"
    }
    
    var saveDisabled: Bool {
        description.isEmpty || amount <= 0.00 || noDestinationSelected
    }
    
    var noDestinationSelected: Bool {
        recurringItem == nil && transactionCategory  == nil
    }
    
    var categoryPicker: some View {
        Picker("Category", selection: $transactionCategory) {
            Text("Select category")
                .tag(nil as TransactionCategory?)
            ForEach(TransactionCategory.allCases, id: \.self) { category in
                Text(category.displayName)
                    .tag(category as TransactionCategory?)
            }
        }
    }
    
    var recurringItemPicker: some View {
        Picker("Recurring item", selection: $recurringItem) {
            Text("Select an item")
                .tag(nil as Item?)
            ForEach(items, id: \.self) { item in
                Text(item.itemDescription)
                    .tag(item as Item?)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if destination == .safeToSpend {
                        categoryPicker
                    } else if destination == .recurringItem {
                        recurringItemPicker
                    }
                } header: {
                    Picker("Destination", selection: $destination) {
                        Text("Safe to spend")
                            .tag(TransactionDestination.safeToSpend)
                        Text("Recurring item")
                            .tag(TransactionDestination.recurringItem)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    TextField("Description", text: $description)
                        .focused($focusedField, equals: .description)
                        .textInputAutocapitalization(.sentences)
                        .onSubmit {
                            focusedField = .amount
                        }
                    
                    TextField("Amount",
                              value: $amount,
                              format: .currency(code: currencyCode))
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            
                            Button("Done") {
                                focusedField = nil
                            }
                        }
                    }
                    
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { transactionType in
                            Text(transactionType.displayName)
                                .tag(transactionType)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(confirmButtonTitle) {
                        guard let destination else {
                            return
                        }
                        if let transaction {
                            transaction.destination = destination
                            transaction.category = transactionCategory
                            transaction.item = recurringItem
                            transaction.amount = amount.removeDecimal
                            transaction.type = type
                            transaction.transactionDescription = description
                            transaction.date = date
                        } else {
                            let newTransaction = Transaction(
                                destination: destination,
                                category: transactionCategory,
                                item: recurringItem,
                                amount: amount.removeDecimal,
                                type: type,
                                transactionDescription: description,
                                date: date)
                            modelContext.insert(newTransaction)
                        }
                        withAnimation {
                            do {
                                try modelContext.save()
                                dismiss()
                            } catch {
                                logger.error("Cannot save transaction changes")
                            }
                        }
                    }
                    .disabled(saveDisabled)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onChange(of: recurringItem) { _, newItem in
                if let newItem {
                    amount = newItem.amount.toDecimal
                    description = newItem.itemDescription
                }
            }
            .onAppear {
                focusedField = .description
                if let transaction {
                    destination = transaction.destination
                    transactionCategory = transaction.category
                    recurringItem = transaction.item
                    // TODO: Set amount amount = transaction.amount.toDouble
                    type = transaction.type
                    description = transaction.transactionDescription
                    date = transaction.date
                }
            }
            .interactiveDismissDisabled()
        }
    }
}
