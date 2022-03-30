//
//  stacksApp.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import SwiftUI

@main
struct stacksApp: App {
    @StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
            StacksView()
                .environmentObject(model)
        }
    }
}
