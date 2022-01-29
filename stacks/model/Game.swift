//
//  Game.swift
//  stacks
//
//  Created by jaydan on 12/10/21.
//

import Foundation


class Game {
    var stack : Stack
    var card : Card?
    var clue : Fact?
    var facts : [Fact]?
    
    var index = 0
    
    init (stack : Stack)
    {
        self.stack = stack;
        nextCard()
    }
    
    func nextCard() {

        let card = stack.cards[index]
        
        index += 1
        
        if index >= stack.cards.count
        {
            index = 0
        }
        
        self.card = card
        self.clue = card.facts[0]
        self.facts = card.facts
    }
}
