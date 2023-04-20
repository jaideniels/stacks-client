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
    @Binding var editing : Bool
    @State var showToolbar : Bool
    @Binding var waiting : Bool
    @State var buttonText = "Edit"
    @State var forceUpdate = true
    
    var stackIndex: Int {
        model.stacks.firstIndex(where: {$0.id == stack.id})!
    }
    
    var cardIndex: Int {
        return model.stacks[stackIndex].cards.firstIndex(where: {$0.id == card.id })!
    }
    
    func factIndex(_ fact : Fact) -> Int {
        return editing ?
            model.stacks[model.getTempStackIndex()].cards[0].facts.firstIndex(where: {$0.id == fact.id })! :
            model.stacks[stackIndex].cards[cardIndex].facts.firstIndex(where: {$0.id == fact.id })!
    }
    
    var body: some View {
        VStack {
            Text("Name")
                .foregroundColor(.gray)
            
            TextField(
                "Name:",
                text: editing ?
                    $model.stacks[model.getTempStackIndex()].cards[0].name :
                    $model.stacks[stackIndex].cards[cardIndex].name
            )
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(!editing)

            Text("Facts")
                .padding()
                .foregroundColor(.gray)

            ForEach(editing ? model.stacks[model.getTempStackIndex()].cards[0].facts : model.stacks[stackIndex].cards[cardIndex].facts, id: \.id) { fact in
                
                HStack {
                    TextField(
                        "Fact:",
                        text: editing ?
                        $model.stacks[model.getTempStackIndex()].cards[0].facts[factIndex(fact)].fact :
                            $model.stacks[stackIndex].cards[cardIndex].facts[factIndex(fact)].fact
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!editing)
                        .padding()

                    if editing && factIndex(fact) == 2 {
                        Button(action: {
                            model.stacks[model.getTempStackIndex()].cards[0].facts.remove(at: 2)
                            model.forceUpdate.toggle()
                        }) {
                            Image(systemName: "minus.circle.fill")
                        }
                        .foregroundColor(.red)
                        .padding(.trailing, 10)
                    }
                }
            }

            if editing && model.stacks[model.getTempStackIndex()].cards[0].facts.count < 3 {
                Button(action: {
                    model.stacks[model.getTempStackIndex()].cards[0].facts.append(Fact(id:-3, fact:""))
                    model.forceUpdate.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
                .padding()
            }
            if waiting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            }
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    if !editing {
                        model.ensureTempStack()
                        let tempCard = model.getTempCard()
                        tempCard!.name = card.name
                        tempCard!.id = card.id
                        tempCard!.facts = card.facts.map { Fact(id:$0.id, fact:$0.fact) }
                        editing = true
                        buttonText = "Save"
                    } else {
                        waiting = true
                        StacksService.patchCard(stack: stack, card: model.stacks[model.getTempStackIndex()].cards[0]) { (card) in
                            if let bangCard = card {
                                model.stacks[stackIndex].cards[cardIndex] = bangCard
                                editing = false
                                waiting = false
                            }
                        }
                    }
                }) {
                    Text(editing ? "Save" : "Edit")
                }
                .disabled(waiting)
            }
        }
        .onDisappear() {
            editing = false
            forceUpdate.toggle()
        }
    }
}
//
//struct FactsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FactsView()
//    }
//}
