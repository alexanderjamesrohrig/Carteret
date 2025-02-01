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
    let transaction: Transaction?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var items: [Item]
    @Query private var funds: [Fund]
    @FocusState private var focusedField: InputField?
    @State private var destination: TransactionDestination?
    @State private var transactionCategory: TransactionCategory?
    @State private var recurringItem: Item?
    @State private var selectedFund: Fund?
    @State private var description: String = ""
    @State private var inputAmount: Currency? = nil
    @State private var type: TransactionType = .expense
    @State private var date = Date.now
    @State private var showDifferentAmountAlert: Bool = false
    
    var title: String {
        transaction == nil ? "Create transaction" : "Edit transaction"
    }
    
    var confirmButtonTitle: String {
        transaction == nil ? "Create" : "Save"
    }
    
    var saveDisabled: Bool {
        if let inputAmount {
            return description.isEmpty || inputAmount <= 0.00 || noDestinationSelected
        } else {
            return true
        }
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
    
    var fundPicker: some View {
        Picker("Fund", selection: $selectedFund) {
            Text("Select a fund")
                .tag(nil as Fund?)
            
            ForEach(funds, id: \.self) { fund in
                Text(fund.fundDescription)
                    .tag(fund as Fund?)
            }
        }
    }
    
    var differentRecurringAmount: Bool {
        destination == .recurringItem && recurringItem?.currencyAmount != inputAmount
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Destination", selection: $destination) {
                        Text("Safe to spend")
                            .tag(TransactionDestination.safeToSpend)
                        
                        Text("Recurring item")
                            .tag(TransactionDestination.recurringItem)
                        
                        Text("Fund")
                            .tag(TransactionDestination.fund)
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    switch destination {
                    case .safeToSpend: categoryPicker
                    case .recurringItem: recurringItemPicker
                    case .fund: fundPicker
                    case nil: EmptyView()
                    }
                }
                
                Section {
                    TextField("Description", text: $description)
                        .focused($focusedField, equals: .description)
                        .textInputAutocapitalization(.sentences)
                        .onSubmit {
                            focusedField = .amount
                        }
                    
                    CurrencyField(amount: $inputAmount, focusedField: $focusedField)
                    
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
                        if destination == nil {
                            return
                        }
                        if differentRecurringAmount {
                            showDifferentAmountAlert = true
                            return
                        }
                        save(transaction: transaction)
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
                    inputAmount = newItem.currencyAmount
                    description = newItem.itemDescription
                }
            }
            .onAppear {
                if let transaction {
                    destination = transaction.destination
                    transactionCategory = transaction.category
                    recurringItem = transaction.item
                    selectedFund = transaction.fund
                    inputAmount = transaction.currencyAmount
                    type = transaction.type
                    description = transaction.transactionDescription
                    date = transaction.date
                } else {
                    focusedField = .description
                }
            }
            .alert("Recurring item has a different amount",
                   isPresented: $showDifferentAmountAlert,
                   actions: {
                Button("Discard the difference") {
                    save(transaction: transaction)
                }
                
                Button("Save as transaction") {
                    destination = .safeToSpend
                    transactionCategory = .other
                    recurringItem = nil
                    save(transaction: transaction)
                }
                
                Button("Cancel", role: .cancel) {
                    showDifferentAmountAlert = false
                }
            }, message: {
                Text("The recurring item you selected has a different amount. Recurring items are not used to calculate your safe to spend amount. Would you like to discard the difference or save this entry as a one time transaction?")
            })
            .interactiveDismissDisabled()
        }
    }
    
    func save(transaction: Transaction?) {
        guard let destination,
              let inputAmount else {
            logger.error("Transaction destination is nil")
            return
        }
        if let transaction {
            transaction.destination = destination
            transaction.category = transactionCategory
            transaction.item = recurringItem
            transaction.fund = selectedFund
            transaction.currencyAmount = inputAmount
            transaction.type = type
            transaction.transactionDescription = description
            transaction.date = date
        } else {
            let newTransaction = Transaction(
                destination: destination,
                category: transactionCategory,
                item: recurringItem,
                fund: selectedFund,
                amount: inputAmount,
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
}

#Preview {
    let helper = PreviewHelper()
    return EditTransactionView(transaction: nil)
        .modelContainer(helper.container)
}
