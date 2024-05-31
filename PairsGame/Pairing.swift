//
//  Pairing.swift
//  PairsGame
//
//  Created by Olha Pylypiv on 30.05.2024.
//

import Foundation

class Pairing {
    var cards = [Card]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    var score = 0
    
    enum MatchResult {
        case match
        case noMatch
        case singleCard
        case none
    }
    
    func chooseCard(at index: Int) -> MatchResult {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // matchIndex: This is the index of the currently face-up card, if there is one.
                // index: This is the index of the card that has just been chosen by the player.
                // The condition matchIndex != index is used to ensure that the chosen card is different from the currently face-up card. This is necessary because you don't want to compare a card to itself when checking for a match.
                
                // There is already one card face up
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2 // Increase score by 2 for a match
                    return .match
                } else {
                    score -= 1 // Decrease score by 1 for a mismatch
                    return .noMatch
                }
            } else {
                // either no cards or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
                return .singleCard
            }
        }
        return .none
    }
    
    init(numberOfPairsOfCards: Int){
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        //TODO: Shuffle tha cards
        cards.shuffle()
    }
}
