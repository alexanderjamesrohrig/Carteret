//
//  FundDetailView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 2/27/25.
//

import SwiftUI

struct FundDetailView: View {
    
    let fund: Fund
    
    @State private var showArchiveAlert = false
    
    var progress: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        let formatted = formatter.string(from: NSNumber(floatLiteral: fund.progress))
        assert(formatted != nil)
        guard let formatted else {
            assertionFailure("Progress string is nil")
            return ""
        }
        return formatted
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .center) {
                    Text(fund.currentBalance.display)
                        .fontWeight(.heavy)
                        .fontDesign(.rounded)
                        .font(.largeTitle)
                    
                    Text(fund.fundDescription)
                        .font(.headline)
                }
                .listRowBackground(Color.clear)
                .frame(maxWidth: .infinity)
            }
            
            Section {
                LabeledContent("Goal", value: fund.goalAmount.display)
                
                LabeledContent("Progress", value: progress)
            }
            
            // TODO: Add balance line chart
            
            if !fund.transactions.isEmpty {
                Section("History") {
                    ForEach(fund.transactions) { transaction in
                        // TODO: New row design
                        TransactionRowView(transaction: transaction)
                    }
                }
            }
            
            Section {
                Button("Archive", role: .destructive) {
                    showArchiveAlert = true
                }
                // TODO: Add alert
//                .alert(archiveAlertTitle, isPresented: $showArchiveAlert) {
//                    Button("Archive", role: .destructive) {
//                        item.set(state: .archived)
//                        withAnimation {
//                            do {
//                                try modelContext.save()
//                                dismiss()
//                            } catch {
//                                logger.error("Cannot archive fund")
//                            }
//                        }
//                    }
//
//                    Button("Cancel", role: .cancel) {
//                        showArchiveAlert = false
//                    }
//                }
            } footer: {
                Text("Fund will be removed from list, but previous transactions will remain labeled with this fund.")
            }
        }
    }
}

#Preview {
    FundDetailView(fund: Fund(description: "Preview",
                              goalAmount: 106.84,
                              transactions: [],
                              fundRepeat: .none))
}
