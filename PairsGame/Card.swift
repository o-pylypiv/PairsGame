//
//  Card.swift
//  PairsGame
//
//  Created by Olha Pylypiv on 30.05.2024.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getUnqueIdetifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init (){
        self.identifier = Card.getUnqueIdetifier()
    }
}
