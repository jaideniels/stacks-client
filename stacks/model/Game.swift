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
    var clue : Clue?
    var facts : [Fact]?
    var score : Score?
    var learning : Bool = true
    var learningDeck : [Card] = []
    
    var index = 0
    let learningDeckSize : Int = 5
    
    init (stack : Stack)
    {
        self.stack = stack;
        updateLearningDeck()
        nextCard()
    }
    
    private func updateScore() {
        if let bangScore = score {
            StacksService.putScore(score: bangScore)  { score in
                
            }
        }
    }
    
    func noit() {
        if let bangScore = score {
            bangScore.score = min(bangScore.score + 1, 5)
        }
        updateScore()
    }
    
    func dunnoit() {
        if let bangScore = score {
            bangScore.score = max(bangScore.score - 1, 1)
        }
        updateScore()
    }
    
    func cardLearned(inCard : Card?) -> Bool {
        
        if let activeCard = inCard {
            let model = Model.getModel()
            
            var totalScore = 0
            for clue in activeCard.clues {
                totalScore += model.getScore(clue_id: clue.id).score
            }
            
            let averageScore = totalScore / activeCard.clues.count
            
            if averageScore < 5 {
                return false
            }
            
            return true;
        } else {
            return false
        }
    }
    
    func updateLearningDeck() {
        
        learningDeck.removeAll()
        
        for candidateCard in stack.cards {
            if !cardLearned(inCard:candidateCard) {
                learningDeck.append(candidateCard)
            }
            
            if learningDeck.count == 5 {
                self.learning = true;
                return
            }
        }
        
        self.learning = false
    }
    
    func nextCard() {
        if stack.cards.isEmpty {
            return
        }
            
        if learning && cardLearned(inCard:self.card) {
            updateLearningDeck()
        }

        var activeStack = stack.cards
        
        if (learning) {
            activeStack = learningDeck
        }
        
        var nextCard : Card
        repeat {
            nextCard = activeStack.randomElement()!
        } while self.card != nil && nextCard == self.card && self.stack.cards.count > 1
        
        let nextClue = nextCard.clues.randomElement()
        
        self.card = nextCard
        self.clue = nextClue
        self.facts = nextCard.facts

        // grab the score from the local cache
        self.score = Model.getModel().getScore(clue_id: clue!.id)
    }
}
