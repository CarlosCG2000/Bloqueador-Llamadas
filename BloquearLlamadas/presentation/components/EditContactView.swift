//
//  EditContactView.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 5/5/25.
//

import SwiftUI

struct EditContactView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var id: UUID
    @State private var name: String
    @State private var phone: String
    
    let originalContact: ContactModel
    let onSave: (ContactModel) -> Void
    
    init(contact: ContactModel, onSave: @escaping (ContactModel) -> Void) {
        self._id = State(initialValue: contact.id)
        self._name = State(initialValue: contact.nameUser)
        self._phone = State(initialValue: contact.numberPhone)
        self.originalContact = contact
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nombre")) {
                    TextField("Nombre", text: $name)
                }
                
                Section(header: Text("Número")) {
                    TextField("Número de teléfono", text: $phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Editar contacto")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        let updatedContact = ContactModel(
                            id: id,
                            numberPhone: phone,
                            nameUser: name
                        )
                        onSave(updatedContact)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
