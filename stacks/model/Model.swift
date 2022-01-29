//
//  UserData.swift
//  stacks
//
//  Created by jaydan on 12/9/21.
//

import Foundation
import Combine

final class Model: ObservableObject {
    @Published var stacks = [Stack]()
    @Published var token = String()
}
