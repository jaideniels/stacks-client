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
    
    var stackIndex: Int {
        model.stacks.firstIndex(where: {$0.id == stack.id})!
    }

    init(stack: Stack) {
        self.stack = stack;
    }
    
    var body: some View {
        List(stack.cards) { card in
            NavigationLink(destination: FactsView(stack: stack, card: card)) {
                Text("\(card.name)")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    model.ensureTempStack()
                    showingPopover = true
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
                FactsView(stack: model.getTempStack()!, card: model.getTempCard()!)
                    .offset(y:60)
                if waiting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
                Spacer()
            }

        }
    }
}


//struct StackView_Previews: PreviewProvider {
//    static var previews: some View {
//        StackView()
//    }
//}
