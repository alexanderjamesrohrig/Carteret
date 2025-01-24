//
//  ContentView.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var loans: [Loan]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(loans) { loan in
                    NavigationLink {
                        LoanView()
                            .navigationTitle("Loan Title")
                    } label: {
                        Text(loan.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {}
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(loans[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Loan.self, inMemory: true)
}
