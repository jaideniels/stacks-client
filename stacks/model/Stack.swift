//
//  Stack.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation

class Stack : Codable, Identifiable, ObservableObject {
    var id : Int
    var name : String
    var cards : [Card]
    
    init(id: Int, cards: [Card], name: String)
    {
        self.id = id
        self.cards = cards
        self.name = name
    }
    
    func isTempStack() -> Bool {
        return id == TEMP_STACK_ID
    }
    
    public static func createTempStack() -> Stack {
        return Stack(id: TEMP_STACK_ID, cards: [Card.createTempCard()], name: "Temp Stack")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case cards = "cards"
    }
}
