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
    @Published var stacks = [Stack]()
    @Published var token = String()
    @Published var showAddButton = false
    @Published var onAddButton : (() -> Void)?
    
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
