//
//  ContentViewModel.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import Foundation
import SwiftData
import CallKit

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
    
    /// Función para filtrar contactos según el nombre.
    ///
    /// Esta función toma una lista de contactos y devuelve una nueva lista que contiene solo aquellos contactos cuyo nombre coincide con el filtro proporcionado.
    ///
    /// - Parameters:
    ///     - contacts: La lista de contactos a filtrar.
    ///
    /// - Returns: Una lista de contactos filtrados según el nombre.
    /// - Throws: Ninguno.
    /// - Important: El filtro se aplica de forma insensible a mayúsculas y minúsculas.
    ///
    /// ## Ejemplo de uso
    /// ```swift
    ///   let filteredContacts = filterContacts(from: contacts)
    ///
    ///   if nameFilter.isEmpty {
    ///     print("No hay filtro aplicado")
    ///    } else {
    ///     print("Filtro aplicado: \(nameFilter)")
    ///    }
    /// ```
    ///
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

    /// Función para limpiar el filtro aplicado.
    ///
    /// Esta función restablece el filtro de búsqueda a una cadena vacía, eliminando cualquier filtro previamente aplicado.
    ///
    /// - Parameters: Ninguno.
    /// - Returns: Ninguno.
    /// - Throws: Ninguno.
    /// - Important: Esta función no afecta a la lista de contactos, solo restablece el filtro.
    func clearFilter() {
        nameFilter = ""
    }
    
    /// Cargar los prefijos de país desde un archivo JSON.
    ///
    /// Esta función carga los prefijos de país desde un archivo JSON ubicado en el paquete principal de la aplicación.
    /// Si el archivo no se encuentra o hay un error al decodificarlo, se imprime un mensaje de error.
    ///
    /// - Parameters: Ninguno.
    /// - Returns: Ninguno.
    /// - Throws: Ninguno.
    ///
    /// ## Ejemplo de uso
    /// ```swift
    ///   loadPrefixes()
    ///   if countryPrefixes.isEmpty {
    ///     print("No se encontraron prefijos de país.")
    ///   } else {
    ///     print("Prefijos de país cargados correctamente.")
    ///   }
    ///```
    ///
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

    /// Agregar un nuevo contacto a la lista de contactos.
    ///
    /// Esta función toma una lista de contactos y un contexto de modelo, valida los campos de entrada y guarda el nuevo contacto en la base de datos.
    /// Si hay un error durante el proceso, se establece un mensaje de error.
    ///
    /// - Parameters:
    ///    - contacts: La lista de contactos existentes. ``ContactModel``.
    ///    - modelContext: El contexto del modelo utilizado para guardar el nuevo contacto.
    /// - Returns: Void.
    /// - Throws: Ninguno.
    /// - Important: Asegúrate de que el contexto del modelo esté configurado correctamente antes de llamar a esta función.
    ///
    /// ## Ejemplo de uso
    /// ```swift
    ///   addContact(to: contacts, modelContext: modelContext)
    ///   if errorMessage == nil {
    ///     print("Contacto agregado correctamente.")
    ///     } else {
    ///     print("Error al agregar contacto: \(errorMessage!)")
    ///     }
    ///     ```
    ///
    func addContact(to contacts: [ContactModel], modelContext: ModelContext) {
        errorMessage = nil // Limpiar error anterior
        
        // Validar campos
        guard !phoneField.trimmingCharacters(in: .whitespaces).isEmpty,
              !nameField.trimmingCharacters(in: .whitespaces).isEmpty else { /// validar que no esten vacios
            errorMessage = "Nombre o número vacío"
            return
        }
        
        // Validar formato de número
        let phoneRegex = "^[0-9]{9}$" // Formato de número español (9 dígitos)
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex) // Expresión regular para validar el número de teléfono
        guard phonePredicate.evaluate(with: phoneField) else {
            errorMessage = "Formato de número inválido"
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
    
    func updateContact(_ updated: ContactModel, contacts: [ContactModel], modelContext: ModelContext) {
        // Busca el objeto persistido en SwiftData (por referencia)
         if let contact = contacts.first(where: { $0.id == updated.id }) {
             // Modifica directamente los campos deseados
             contact.nameUser = updated.nameUser
             contact.numberPhone = updated.numberPhone

             // Guarda los cambios (opcional si estás dentro de una transacción automática)
             do {
                 try modelContext.save()
             } catch {
                 print("Error al guardar contacto actualizado: \(error)")
             }
         }
    }

    func reloadExtension() {
        // Cargar la extensión de bloqueo de llamadas
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: bundleIdentifier) { error in
            if let error = error {
                print("Error cargando extension: \(error.localizedDescription)")
            } else {
                print("Extension reloaded successfully")
            }
        }
    }

}
