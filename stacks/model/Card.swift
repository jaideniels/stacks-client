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

    init(id: Int, fact: String) {
        self.id = id
        self.fact = fact
    }
    
    public static func createTempFacts() -> [Fact] {
        return [Fact(id: TEMP_STACK_ID, fact: ""), Fact(id: TEMP_STACK_ID - 1, fact: "")]
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fact = "fact"
    }
}

class Card: Codable, Identifiable {
    var id: Int
    var facts: [Fact]
    var name: String
    
    init(id: Int, facts: [Fact], name: String) {
        self.id = id
        self.facts = facts
        self.name = name
    }
    
    public static func createTempCard() -> Card {
        return Card(id: TEMP_STACK_ID, facts: Fact.createTempFacts(), name: "")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case facts = "facts"
        case name = "name"
    }
}
