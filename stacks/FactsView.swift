//
//  FactsView.swift
//  stacks
//
//  Created by jaydan on 1/30/22.
//

import SwiftUI

struct FactsView: View {
    @EnvironmentObject var model: Model
    var stack : Stack
    var card : Card
    
    var stackIndex: Int {
        model.stacks.firstIndex(where: {$0.id == stack.id})!
    }
    
    var cardIndex: Int {
        return model.stacks[stackIndex].cards.firstIndex(where: {$0.id == card.id })!
    }
    
    init(stack: Stack, card: Card) {
        self.stack = stack;
        self.card = card;
    }
    
    var body: some View {
        VStack {
            Text("Name")
                .foregroundColor(.gray)
            
            TextField(
                "Name:",
                text: $model.stacks[stackIndex].cards[cardIndex].name
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text("Facts")
                .padding()
                .foregroundColor(.gray)

            ForEach($model.stacks[stackIndex].cards[cardIndex].facts.indices) { factIndex in
                
                TextField(
                    "Fact:",
                    text: $model.stacks[stackIndex].cards[cardIndex].facts[factIndex].fact
                )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Spacer()
        }
    }
}
//
//struct FactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FactsView()
//    }
//}
