//
//  Score.swift
//  stacks
//
//  Created by jaydan on 7/1/22.
//

import Foundation

class Score : Codable, Identifiable {
    var score : Int
    var clue_id : Int
    
    init(clue_id: Int, score: Int) {
        self.clue_id = clue_id
        self.score = score
    }
    
    enum CodingKeys: String, CodingKey {
        case score = "score"
        case clue_id = "clue_id"
    }
}
