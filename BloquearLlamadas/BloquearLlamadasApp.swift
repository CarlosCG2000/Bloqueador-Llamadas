//
//  BloquearLlamadasApp.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import SwiftUI

// 1. Crear un target extension para saber si se tiene que bloquear un número o no, en este caso se utiliza una extension de tipo `Call Directory Extension`, pero se puede utilizar cualquier otro tipo de extension que se desee utilizar. Esta extension se encarga de bloquear los números que se le indiquen en la base de datos de SwifdData

// Tip: desde el Iphone fisico hay que ir a ajuste y a `Call Blocking & Identification`, luego al pulsar saldra mi extension de MyExtensionCall, la cual se debe activar para que funcione la extension.

// 3. ContactModel.swift es el modelo de datos que se va a utilizar para guardar los contactos que se van a bloquear, en este caso solo guardamos el número y el nombre del contacto, pero se puede agregar más información si se desea. Este modelo se guarda en la base de datos de SwiftData, pero se puede cambiar a CoreData o cualquier otra base de datos que se desee utilizar.

// 4. ContainerDB.swift es el contenedor de la base de datos, en este caso se utiliza SwiftData, pero se puede cambiar a CoreData o cualquier otra base de datos que se desee utilizar. Este contenedor se utiliza para guardar los contactos que se van a bloquear y para cargar los contactos que ya se han guardado.

// Añadir en 'Capabilities' dentro del target de la aplicación principal: 'App Groups' para poder compartir datos (de la base de datos) entre la aplicación y la extensión de bloqueo de llamadas (diferentes target). Pulsamos el botón '+' y luego 'App Groups' y añadimos el grupo de la aplicación, en este caso 'group.com.carloscg00.BloquearLlamadas', pero se puede cambiar a cualquier otro nombre que se desee utilizar. Este grupo es el que se va a utilizar para compartir los datos entre la aplicación y la extensión de bloqueo de llamadas. Este grupo se debe añadir tanto en la aplicación como en la extensión de bloqueo de llamadas.

// 5. BloquearLlamadasApp.swift es el archivo principal de la aplicación, en este caso solo se carga la vista principal, pero se puede agregar más información si se desea. Este archivo se utiliza para cargar la aplicación y para cargar la vista principal de la aplicación.

// CallDirectoryHandler.swift es el archivo que se encarga de bloquear los números que se le indiquen en la base de datos de SwifdData, en este caso solo se bloquean los números que se le indiquen en el array allPhoneNumbers, pero se puede cambiar a cualquier otro array que se desee utilizar. Este archivo se utiliza para cargar la extensión de bloqueo de llamadas y para bloquear los números que se le indiquen en la base de datos.

// Para que conozca el contenedor de la base de datos, se le pasa el contenedor a la extensión de bloqueo de llamadas, en este caso se utiliza el contenedor de la aplicación, pero se puede cambiar a cualquier otro contenedor que se desee utilizar. Este contenedor se utiliza para cargar los contactos que se van a bloquear y para cargar los contactos que ya se han guardado. Se pasa a traves del inpector de atriubtuos se habilita el Target Membership y se selecciona el target de la aplicación, para que la extensión de bloqueo de llamadas pueda acceder al contenedor de la base de datos. Este contenedor se debe añadir tanto en la aplicación como en la extensión de bloqueo de llamadas. Igual para el fichero ContactModel que se utiliza para guardar los contactos que se van a bloquear y para cargar los contactos que ya se han guardado. Este fichero se debe añadir tanto en la aplicación como en la extensión de bloqueo de llamadas.

@main
struct BloquearLlamadasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(ContainerDB.shared.container) // para poder usar la base de datos en la app
    }
}
