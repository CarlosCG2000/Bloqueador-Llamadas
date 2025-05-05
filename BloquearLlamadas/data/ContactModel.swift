//
//  ContactModel.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 4/5/25.
//

import Foundation
import SwiftData

@Model
class ContactModel {
    var id: UUID
    var numberPhone: String
    var nameUser: String
    
    init(id: UUID = UUID(), numberPhone: String, nameUser: String) {
        self.id = id
        self.numberPhone = numberPhone
        self.nameUser = nameUser
    }
}
