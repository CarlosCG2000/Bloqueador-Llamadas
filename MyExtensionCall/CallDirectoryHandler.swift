//
//  CallDirectoryHandler.swift
//  MyExtensionCall
//
//  Created by Carlos C on 4/5/25.
//

import Foundation
import CallKit
import SwiftData

@MainActor
class CallDirectoryHandler: CXCallDirectoryProvider {

    let container = ContainerDB.shared.container // para poder acceder a la base de datos
    
    func fetchContacts() throws -> [ContactModel] {
        let request = FetchDescriptor<ContactModel>(sortBy: [SortDescriptor(\ContactModel.numberPhone, order: .forward)]) // forward es el orden ascendente y backward es el orden descendente
        do {
            return try container.mainContext.fetch(request)
        } catch {
            print("Error al obtener los contactos: \(error)")
            return []
        }
    }
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        Task {
            /// let allPhoneNumbers: [CXCallDirectoryPhoneNumber] = [34123456789, 34896866555, 34001122334] /// numeros que queremos bloquear, importante deben de empezar con 34 (prefijo de donde sea el número)
            let blockedContacts: [ContactModel] = try fetchContacts()
            
            let blockedNumbers: [CXCallDirectoryPhoneNumber] = blockedContacts.map { contact in
                let blockedNumber: CXCallDirectoryPhoneNumber? = Int64(contact.numberPhone)
                return blockedNumber
            }.compactMap{ $0 } // nos quedamos con los números que no son nil, es decir, los números válidos y convertibles a CXCallDirectoryPhoneNumber
            
            for phoneNumber in blockedNumbers {
                context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber) /// agregar el número a la lista de bloqueo
            }
            
            await context.completeRequest() /// finalizar la petición
        }
        
    }

}

