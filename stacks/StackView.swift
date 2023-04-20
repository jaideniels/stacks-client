//
//  StackView.swift
//  stacks
//
//  Created by jaydan on 1/30/22.
//

import SwiftUI

struct StackView: View {
    @EnvironmentObject var model: Model
    var stack : Stack
    @State var showingPopover = false
    @State var waiting = false
    @State var editingFacts = false
    
    var stackIndex: Int {
        model.stacks.firstIndex(where: {$0.id == stack.id})!
    }

    func cardIndex(_ card : Card) -> Int {
        return model.stacks[stackIndex].cards.firstIndex(where: {$0.id == card.id })!
    }
    
    var body: some View {
        List(stack.cards, id: \.id) { card in
            NavigationLink(destination: FactsView(stack: stack, card: card, editing: $editingFacts, showToolbar: true, waiting: $waiting)) {
                Text("\(card.name)")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    model.ensureTempStack()
                    showingPopover = true
                    editingFacts = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .popover(isPresented: $showingPopover) {
            VStack {
                HStack {
                    Spacer()
                    Button("Save") {
                        waiting = true
                        StacksService.addCard(stack: stack, card: model.getTempCard()!) { (card) in
                            if let bangCard = card {
                                model.stacks[stackIndex].cards.append(bangCard)
                                showingPopover = false
                                waiting = false
                            }
                        }
                    }
                    .padding(.trailing, 20)
                }
                .offset(y: 30)
                FactsView(stack: model.getTempStack()!, card: model.getTempCard()!, editing: $editingFacts, showToolbar: false, waiting: $waiting)
                    .offset(y:60)

                Spacer()
            }
            .onDisappear() {
                editingFacts = false
            }
        }
    }
}


//struct StackView_Previews: PreviewProvider {
//    static var previews: some View {
//        StackView()
//    }
//}
