//
//  Card.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation

class Fact: Codable, Identifiable {
    var id: Int
    var fact: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fact = "fact"
    }
}

class Card: Codable, Identifiable {
    var id: Int
    var facts: [Fact]
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case facts = "facts"
        case name = "name"
    }
}
