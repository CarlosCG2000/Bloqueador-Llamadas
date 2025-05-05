//
//  CountryPrefix.swift
//  BloquearLlamadas
//
//  Created by Carlos C on 5/5/25.
//

import Foundation

struct CountryPrefix: Codable, Hashable, Identifiable {
    var id: String { prefix }
    let name: String
    let prefix: String
}
