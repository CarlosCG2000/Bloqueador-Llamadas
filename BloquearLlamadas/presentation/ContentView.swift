//
//  ContentView.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import SwiftUI
import CallKit
import SwiftData

struct ContentView: View {
    
    @Query(sort: \ContactModel.nameUser, order: .forward) var contacts: [ContactModel]
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var vm: ContentViewModel = ContentViewModel()

    var body: some View {
        let filteredContacts = vm.filterContacts(from: contacts)

        NavigationStack {
            VStack {
                SearchBarView(vm: vm)

                AddContactFormView(vm: vm, contacts: contacts, modelContext: modelContext)

                ContactListView(contacts: filteredContacts) { indexSet in
                    for index in indexSet {
                        let contact = contacts[index]
                        vm.deleteContact(contact, modelContext: modelContext)
                    }
                }
            }
            .navigationTitle("📞 Bloqueador App")
            .padding()
        }
        .onAppear {
            vm.reloadExtension()
        }
    }
}

#Preview {
    ContentView()
}
