//
//  ContactListView.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//
import SwiftUI
import SwiftData

struct ContactListView: View {
    
    @State private var selectedContact: ContactModel? = nil
    @State private var isEditing = false
    
    @Bindable var vm: ContentViewModel
    var contacts: [ContactModel]
    var modelContext: ModelContext
    
    var onDelete: (IndexSet) -> Void // Closure para manejar la eliminación de contactos
    
    var body: some View {
        List {
            ForEach(contacts) { contact in
                HStack {
                    Text(contact.nameUser)
                        .font(.headline)
                    Spacer()
                    Text(contact.numberPhone)
                        .font(.subheadline)
                }
                .contentShape(Rectangle()) // Hace toda la fila táctil
                .onTapGesture {
                    selectedContact = contact
                    isEditing = true
                }
                /**.swipeActions(edge: .trailing) {
                    Button("Editar") {
                        selectedContact = contact
                        isEditing = true
                    }
                    .tint(.blue)
                }*/
            }
            .onDelete(perform: onDelete)
        }
        .sheet(item: $selectedContact) { contact in /// se presenta solo si selectedContact != nil.
            EditContactView(contact: contact) { updatedContact in
                vm.updateContact(updatedContact, contacts: contacts, modelContext: modelContext)
            }
        }
    }
}
