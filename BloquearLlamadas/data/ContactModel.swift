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
    var numberPhone: String
    var nameUser: String
    
    init(numberPhone: String, nameUser: String) {
        self.numberPhone = numberPhone
        self.nameUser = nameUser
    }
}
