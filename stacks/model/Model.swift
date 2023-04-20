//
//  UserData.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation
import Combine

let TEMP_STACK_ID = -1

final class Model: ObservableObject {
    static let singleton = Model()
    
    @Published var stacks = [Stack]()
    @Published var token = String()
    @Published var showAddButton = false
    @Published var onAddButton : (() -> Void)?
    @Published var forceUpdate = false
    @Published var scores = [Int : Score]()

    static func getModel() -> Model {
        return singleton
    }
    
    func updateScore(score : Score) {
        scores[score.clue_id] = score
    }
    
    func getScore(clue_id: Int) -> Score {
        var score : Score?
        
        score = scores[clue_id]
        
        if let bangScore = score {
            return bangScore
        } else {
            let newScore = Score(clue_id: clue_id, score: 0)
            scores[clue_id] = newScore
            return newScore
        }
    }
    
    func ensureTempStack() {
        for (index, stack) in stacks.enumerated() {
            if stack.id == TEMP_STACK_ID {
                stacks.remove(at: index)
            }
        }
        let tempStack = Stack.createTempStack()
        stacks.append(tempStack)
    }

    func getTempStack() -> Stack? {
        for stack in stacks {
            if stack.id == TEMP_STACK_ID {
                return stack
            }
        }
        return nil;
    }
    
    func getTempStackIndex() -> Int {
        for (index, stack) in stacks.enumerated() {
            if stack.id == TEMP_STACK_ID {
                return index
            }
        }
        return -1
    }
    
    func getTempCard() -> Card? {
        for stack in stacks {
            if stack.id == TEMP_STACK_ID {
                for card in stack.cards {
                    if card.id == TEMP_STACK_ID {
                        return card
                    }
                }
            }
        }
        return nil;
    }
}
