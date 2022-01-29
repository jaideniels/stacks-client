//
//  ContentView.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import SwiftUI

struct StacksView: View {
    @EnvironmentObject var model: Model

    init() {
       UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        List(model.stacks) { stack in
            NavigationLink(destination: GameView(stack: stack)) {
                Text("\(stack.name)")
            }
        }
        .background(Color.white)
        .onAppear() {
            StacksService.loadData(token: model.token) { (stacks) in
                model.stacks = stacks
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StacksView()
            .environmentObject({ () -> Model in
                let envObj = Model()
                envObj.token = "jaydan_secret_token"
                return envObj
            }() )
    }
}
