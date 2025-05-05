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
            Text("Añadir Nuevo Contacto")
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
                    
                    HStack {
                        Picker(selection: $vm.selectedPrefix, label: Text(vm.selectedPrefix?.name ?? "🌍")) {
                            ForEach(vm.countryPrefixes, id: \.self) { country in
                                Text("\(country.name) +\(country.prefix)")
                                    .tag(country as CountryPrefix?)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(width: 100)
                        
                        TextField("Número telefónico", text: $vm.phoneField, axis: .horizontal)
                            .textFieldStyle(.roundedBorder)
                            .padding(.trailing)
                            .onChange(of: vm.phoneField) { _, _ in
                                vm.errorMessage = nil
                            }
                    }
                }
                
                Button(action: {
                    vm.addContact(to: contacts, modelContext: modelContext)
                    if vm.errorMessage == nil { vm.clearContact() }
                }) {
                    Text("🔐")
                        // .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                }
            }
            /// Mostrar error si existe
            if let errorMessage = vm.errorMessage {
                 Text(errorMessage)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // .multilineTextAlignment(.trailing)
                     .foregroundColor(.red)
                     .font(.callout)
                     .padding(.horizontal)
            }
        }
    }

}
