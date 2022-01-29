//
//  Stack.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation

class Stack : Codable, Identifiable {
    var id : Int
    var name : String
    var cards : [Card]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case cards = "cards"
    }
}
