//
//  EditItemView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/16/25.
//

import SwiftUI
import SwiftData
import Foundation
import OSLog

struct EditItemView: View {
    let logger = Logger(subsystem: Constant.carteretSubsystem, category: "EditItemView")
    let currencyCode = Locale.current.currency?.identifier ?? ""
    let item: Item?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: InputField?
    @State private var description: String = ""
    @State private var amount: Currency? = nil
    @State private var type: TransactionType = .expense
    @State private var repeatSelection: Repeat = .everyWeek
    @State private var category: ItemCategory?
    @State private var showArchiveAlert = false
    
    var title: String {
        item == nil ? "Create item" : "Edit item"
    }
    
    var confirmButtonTitle: String {
        item == nil ? "Create" : "Save"
    }
    
    var saveDisabled: Bool {
        if let amount {
            return description.isEmpty || amount <= 0.00 || category == nil
        } else {
            return true
        }
    }
    
    var archiveAlertTitle: String {
        if let item {
            "Archive \"\(item.itemDescription)\"?"
        } else {
            Constant.nil
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Description", text: $description)
                        .focused($focusedField, equals: .description)
                        .textInputAutocapitalization(.sentences)
                        .onSubmit {
                            focusedField = .amount
                        }
                    
                    // TODO: If savings, allow to set % of income
                    CurrencyField(amount: $amount, focusedField: $focusedField)
                    
                    Picker("Type", selection: $type) {
                        ForEach(TransactionType.allCases, id: \.self) { transactionType in
                            Text(transactionType.displayName)
                                .tag(transactionType)
                        }
                    }
                    
                    Picker("How often?", selection: $repeatSelection) {
                        ForEach(Repeat.itemRepeats, id: \.self) { repeatItem in
                            Text(repeatItem.displayName)
                                .tag(repeatItem)
                        }
                    }
                    
                    Picker("Category", selection: $category) {
                        Text("Select category")
                            .tag(nil as ItemCategory?)
                        ForEach(ItemCategory.allCases, id: \.self) { categoryItem in
                            Text(categoryItem.displayName)
                                .tag(categoryItem as ItemCategory?)
                        }
                    }
                } footer: {
                    if let item {
                        Text("\(item.weeklyAmount.display) every week.")
                    }
                }
                
                if item != nil {
                    Section {
                        Button("Archive", role: .destructive) {
                            showArchiveAlert = true
                        }
                    } footer: {
                        Text("Item will be removed from list and weekly budget calculations, but previous transactions will remain labeled with this recurring item.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(confirmButtonTitle) {
                        guard let category,
                              let amount else {
                            return
                        }
                        if let item {
                            item.itemDescription = description
                            item.currencyAmount = amount
                            item.type = type
                            item.itemRepeat = repeatSelection
                            item.category = category
                        } else {
                            let newItem = Item(
                                itemDescription: description,
                                amount: amount,
                                type: type,
                                itemRepeat: repeatSelection,
                                category: category
                            )
                            modelContext.insert(newItem)
                        }
                        withAnimation {
                            do {
                                try modelContext.save()
                                dismiss()
                            } catch {
                                logger.error("Cannot save item changes")
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
            .alert(archiveAlertTitle, isPresented: $showArchiveAlert) {
                Button("Archive", role: .destructive) {
                    guard let item else {
                        return
                    }
                    item.set(state: .archived)
                    withAnimation {
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch {
                            logger.error("Cannot archive item")
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    showArchiveAlert = false
                }
            }
            .onAppear {
                if let item {
                    description = item.itemDescription
                    amount = item.currencyAmount
                    type = item.type
                    repeatSelection = item.itemRepeat
                    category = item.category
                } else {
                    focusedField = .description
                }
            }
            .interactiveDismissDisabled()
        }
    }
}
