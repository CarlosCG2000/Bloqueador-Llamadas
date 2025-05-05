//
//  ContentViewModel.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import Foundation
import CallKit
import SwiftData

@MainActor
@Observable
final class ContentViewModel {
    
    // MARK: - Public Properties
    var nameFilter: String = ""
    var phoneField: String = ""
    var nameField: String = ""
    
    var selectedPrefix: CountryPrefix? = CountryPrefix(name: "🇪🇸", prefix: "34")
    var countryPrefixes: [CountryPrefix] = []
    
    var errorMessage: String? = nil  // ← Nuevo para mostrar errores

    let bundleIdentifier = "com.carloscg00.BloquearLlamadas.MyExtensionCall" /// Este identificador debe ser exactamente el Bundle Identifier de tu extensión de Call Directory, es decir, el target de tipo Call Directory Extension en tu proyecto.

    // MARK: - Constructor
    init() {
        loadPrefixes()
    }

    // MARK: - Public Methods
    func filterContacts(from contacts: [ContactModel]) -> [ContactModel] {
        if nameFilter.isEmpty {
            return contacts
        } else {
            print("Filtro aplicado: \(nameFilter)")
            return contacts.filter { nameContact in
                /*$0*/ nameContact.nameUser.localizedCaseInsensitiveContains(nameFilter)
            }
        }
    }

    func clearFilter() {
        nameFilter = ""
    }
    
    func loadPrefixes() {
        guard let url = Bundle.main.url(forResource: "paises", withExtension: "json") else {
            print("No se encontró el archivo JSON.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([CountryPrefix].self, from: data)
            self.countryPrefixes = decoded
            self.selectedPrefix = decoded.first
        } catch {
            print("Error al decodificar JSON: \(error.localizedDescription)")
        }
    }

    func fullPhoneNumber() -> String {
        "\(selectedPrefix?.prefix ?? "")\(phoneField)"
    }

    func addContact(to contacts: [ContactModel], modelContext: ModelContext) {
        errorMessage = nil // Limpiar error anterior
        
        // Validar campos
        guard !phoneField.trimmingCharacters(in: .whitespaces).isEmpty,
              !nameField.trimmingCharacters(in: .whitespaces).isEmpty else { /// validar que no esten vacios
            errorMessage = "Nombre o número vacío"
            return
        }

        // Verificar si el número ya está bloqueado
        if contacts.contains(where: { $0.numberPhone == phoneField }) {
            errorMessage = "Este número ya está bloqueado"
            return
        }

        // Crear y guardar nuevo contacto
        let contact = ContactModel(numberPhone: fullPhoneNumber(), nameUser: nameField)
        
       modelContext.insert(contact)
        
       do {
           try modelContext.save()
           reloadExtension()
       } catch {
           errorMessage = "Error al guardar el contacto"
       }
    }
    
    func clearContact() {
        nameField = ""
        phoneField = ""
        errorMessage = nil
    }
    
    func deleteContact(_ contact: ContactModel, modelContext: ModelContext) {
        print("Bloqueo eliminado: \(contact.numberPhone) con nombre: \(contact.nameUser)")
        modelContext.delete(contact)
        try? modelContext.save() // Importante guardar los cambios después de eliminar el contacto
    }

    func reloadExtension() {
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: bundleIdentifier) { error in
            if let error = error {
                print("Error cargando extension: \(error.localizedDescription)")
            } else {
                print("Extension reloaded successfully")
            }
        }
    }

}
