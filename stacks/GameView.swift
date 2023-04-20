//
//  GameView.swift
//  stacks
//
//  Created by jaydan on 12/10/21.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var model: Model
    var stack : Stack
    var game : Game?
    
    @State var cardFlipped = false
    @State var correct = false
    @State var incorrect = false
    @State var cardVisible = true
    @State var allowHitTesting = false
    @State var offset = 0.0
    @State var clue : Clue
    @State var facts : [Fact]
    @State var cardColor = Color.white
    @State var cardFlipLeft = true
    @State var score = 1

    init(stack: Stack) {
        self.stack = stack;
        self.game = Game(stack: stack)
        clue = game!.clue!
        facts = game!.facts!
    }

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                CardView(animate3d:$cardFlipped, flipLeft:$cardFlipLeft, color: $cardColor, clue: $clue.facts[0], facts: $facts)
                    .offset(x:0, y:offset)
                    .opacity(cardVisible ? 1 : 0)

                VStack {
                    HStack {
                        ForEach (0..<score, id: \.self) { i in
                            Text("🐳")
                                .opacity(correct ? 0.75 : 0)
                                .font(.system(size:50))
                        }
                    }
                    Spacer()
                    HStack {
                        ForEach (0..<score, id: \.self) { i in
                            Text("🐦")
                                .opacity(incorrect ? 0.75 : 0)
                                .font(.system(size:50))
                                .offset(x:0, y:-140)
                        }
                    }
                }
            }
            .allowsHitTesting(!allowHitTesting)
            .gesture(
                DragGesture()
                    .onEnded {value in
                        let dragVertical = abs(value.startLocation.x - value.location.x) < abs(value.startLocation.y - value.location.y)
                        let dragLeft = value.startLocation.x > value.location.x
                        let dragUp = value.startLocation.y > value.location.y
                        
                        if dragVertical
                        {
                            allowHitTesting = true
                            if dragUp {
                                game!.noit()
                            } else {
                                game!.dunnoit()
                            }
                            score = game!.score!.score
                            
                            withAnimation(.easeInOut) {
                                if dragUp {
                                    correct.toggle()
                                } else {
                                    incorrect.toggle()
                                }
                                offset = 1000.0 * (dragUp ? -1 : 1)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)
                            {
                                offset = 0.0
                                cardVisible = false
                                cardFlipped = false
                                game!.nextCard()
                                clue = game!.clue!
                                facts = game!.facts!
                                
                                // fade feedback out
                                withAnimation(.easeInOut(duration:0.4)) {
                                    if dragUp {
                                        correct.toggle()
                                    } else {
                                        incorrect.toggle()
                                    }
                                    cardVisible = true
                                }

                                // slightly delay reenabling gestures
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2)
                                {
                                    allowHitTesting = false
                                }
                            }
                            
                        }
                        else
                        {
                            allowHitTesting = true
                            cardColor = Color(UIColor.darkGray)
                            cardFlipLeft = dragLeft
                            
                            withAnimation(.easeInOut(duration: 0.4)) {
                                self.cardFlipped.toggle()
                                self.cardColor = Color.white
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4)
                            {
                                allowHitTesting = false
                            }
                        }
                    })
            Spacer()
        }
        
    }
        
}

let sampleData = """
 [
   {
     "cards": [
       {
         "clues": [
           {
             "facts": [
               {
                 "fact": "red",
                 "id": 1
               }
             ],
             "id": 1
           },
           {
             "facts": [
               {
                 "fact": "红",
                 "id": 2
               }
             ],
             "id": 2
           },
           {
             "facts": [
               {
                 "fact": "hóng",
                 "id": 3
               }
             ],
             "id": 3
           }
         ],
         "facts": [
           {
             "fact": "red",
             "id": 1
           },
           {
             "fact": "红",
             "id": 2
           },
           {
             "fact": "hóng",
             "id": 3
           }
         ],
         "id": 1,
         "name": "red"
       },
       {
         "clues": [
           {
             "facts": [
               {
                 "fact": "blue",
                 "id": 4
               }
             ],
             "id": 4
           },
           {
             "facts": [
               {
                 "fact": "蓝",
                 "id": 5
               }
             ],
             "id": 5
           },
           {
             "facts": [
               {
                 "fact": "lán",
                 "id": 6
               }
             ],
             "id": 6
           }
         ],
         "facts": [
           {
             "fact": "blue",
             "id": 4
           },
           {
             "fact": "蓝",
             "id": 5
           },
           {
             "fact": "lán",
             "id": 6
           }
         ],
         "id": 2,
         "name": "blue"
       },
       {
         "clues": [
           {
             "facts": [
               {
                 "fact": "orange",
                 "id": 7
               }
             ],
             "id": 7
           },
           {
             "facts": [
               {
                 "fact": "橙",
                 "id": 8
               }
             ],
             "id": 8
           },
           {
             "facts": [
               {
                 "fact": "chéng",
                 "id": 9
               }
             ],
             "id": 9
           }
         ],
         "facts": [
           {
             "fact": "orange",
             "id": 7
           },
           {
             "fact": "橙",
             "id": 8
           },
           {
             "fact": "chéng",
             "id": 9
           }
         ],
         "id": 3,
         "name": "orange"
       }
     ],
     "id": 1,
     "name": "colors"
   },
   {
     "cards": [],
     "id": 3,
     "name": "animals"
   },
   {
     "cards": [],
     "id": 4,
     "name": "cities"
   }
 ]
"""
