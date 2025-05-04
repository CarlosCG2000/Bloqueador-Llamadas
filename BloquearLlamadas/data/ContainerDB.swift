//
//  ContainerDB.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import Foundation
import SwiftData

final class ContainerDB {
        
        static let shared = ContainerDB()
    
        var container: ModelContainer
        let bundleIdentifier = "com.carloscg00.BloquearLlamadas"
    
        private init() {
            do {
                let fullSchema = Schema([ContactModel.self])
                let modelConfig = ModelConfiguration(schema: fullSchema,
                                                         groupContainer: .identifier("group.\(bundleIdentifier)")) /// para compartir la base de datos entre la app y la extension, este identificador corresponde al App Group, y debe coincidir en ambos target en tu app principal y tu extensión MyExtensionCall
                     
                self.container = try ModelContainer(for: fullSchema, configurations: [modelConfig])
    
            } catch {
                print("‼️ Error al crear el contenedor de datos: \(error)")
                fatalError("Error al crear el contenedor de datos: \(error)")
            }
        }
}
