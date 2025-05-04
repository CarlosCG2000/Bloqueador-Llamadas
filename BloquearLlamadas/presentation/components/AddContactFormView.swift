//
//  File.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//
import SwiftUI
import SwiftData

struct AddContactFormView: View {
    
    @Bindable var vm: ContentViewModel
    var contacts: [ContactModel]
    var modelContext: ModelContext
    
    var body: some View {
        VStack {
            Text("Añadir contacto para bloquear")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            HStack {
                VStack {
                    TextField("Nombre de contacto", text: $vm.nameField, axis: .horizontal)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onChange(of: vm.nameField) { _, _ in
                            vm.errorMessage = nil
                        }
                    
                    TextField("Número de teléfono", text: $vm.phoneField, axis: .horizontal)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onChange(of: vm.phoneField) { _, _ in
                            vm.errorMessage = nil
                        }
                }
                
                Button(action: {
                    vm.addContact(to: contacts, modelContext: modelContext)
                }) {
                    Text("Bloquear")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
            }
            /// Mostrar error si existe
            if let errorMessage = vm.errorMessage {
                 Text(errorMessage)
                     .foregroundColor(.red)
                     .font(.callout)
                     .padding(.horizontal)
            }
        }
    }

}
