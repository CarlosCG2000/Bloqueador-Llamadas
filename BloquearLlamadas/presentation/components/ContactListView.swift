//
//  ContactListView.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//
import SwiftUI
import SwiftData

struct ContactListView: View {
    
    var contacts: [ContactModel]
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
            }
            .onDelete(perform: onDelete)
        }
    }
}
