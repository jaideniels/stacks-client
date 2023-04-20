//
//  ContentView.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import SwiftUI

struct StacksView: View {
    @EnvironmentObject var model: Model
    @State var showingAuthSheet : Bool
    @State var editMode : Bool
    @State var dataLoaded = false
     
    init() {
        UITableView.appearance().backgroundColor = .white
        showingAuthSheet = false
        editMode = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(editMode ? "Edit" : "Play", action: {
                    editMode.toggle()
                })
                List(model.stacks) { stack in
                    if (!stack.isTempStack()) {
                        if editMode {
                            NavigationLink(destination: StackView(stack: stack)) {
                                Text("\(stack.name)")
                            }
                        }
                        else {
                            NavigationLink(destination: GameView(stack: stack)) {
                                Text("\(stack.name)")
                            }
                        }
                    }
                }
                .background(Color.white)
                .onAppear() {
                    if !dataLoaded {
                        tryLogin()
                    }
                }
                .sheet(isPresented: $showingAuthSheet, onDismiss: nil) {
                    Spacer()

                    TextField("Token", text:$model.token)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)

                    Spacer()
                    
                    Button("Login", action: {
                        showingAuthSheet.toggle()

                        StacksService.setToken(token: model.token)
                        
                        tryLogin()
                    })
                }
            }
        }
    }

    func tryLogin() {
        StacksService.loadData() { (stacks) in
            if let bangStacks = stacks {
                model.stacks = bangStacks
                dataLoaded = true
                
                StacksService.getScores() { (scores) in
                    if let bangScores = scores {
                        for score in bangScores {
                            model.updateScore(score: score)
                        }
                    }
                }
            }
            else
            {
                showingAuthSheet.toggle()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StacksView()
            .environmentObject({ () -> Model in
                let envObj = Model()
                return envObj
            }() )
    }
}
