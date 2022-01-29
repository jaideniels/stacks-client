//
//  SettingsView.swift
//  stacks
//
//  Created by jaydan on 12/10/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: Model

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                TextField("Token", text:$model.token)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.center)
                    .onAppear() {
                        model.token = "jaydan_secret_token"
                    }
                Spacer()
                
                NavigationLink(destination:StacksView()) {
                    Text("Start Game")
                }.padding()

                Spacer()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Model())
    }
}
