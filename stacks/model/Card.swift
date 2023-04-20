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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Temp IDs are negative and need server-assigned ids
        if (id >= 0) {
            try container.encode(id, forKey: .id)
        }
        try container.encode(fact, forKey: .fact)
     }
}

class Clue : Codable, Identifiable {
    var id: Int
    var facts : [Fact]
    
    init(id: Int, facts: [Fact]) {
        self.id = id
        self.facts = facts
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case facts = "facts"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Temp IDs are negative and need server-assigned ids
        if (id >= 0) {
            try container.encode(id, forKey: .id)
        }
        try container.encode(facts, forKey: .facts)
     }
}

class Card: Codable, Identifiable, Equatable {
    var id: Int
    var facts: [Fact]
    var clues : [Clue]
    var name: String

    init(id: Int, facts: [Fact], name: String) {
        self.id = id
        self.facts = facts
        self.name = name
        self.clues = [Clue]()
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    public static func createTempCard() -> Card {
        return Card(id: TEMP_STACK_ID, facts: Fact.createTempFacts(), name: "")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case facts = "facts"
        case name = "name"
        case clues = "clues"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Temp IDs are negative
        if (id >= 0) {
            try container.encode(id, forKey: .id)
        }
        try container.encode(facts, forKey: .facts)
        try container.encode(name, forKey: .name)
     }
}
