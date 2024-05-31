//
//  ViewController.swift
//  PairsGame
//
//  Created by Olha Pylypiv on 30.05.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var flipsLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    //lazy -- can not have a didSet, They are created only when needed, and so might never be created.
    //The lazy keyword is used for the game property because it depends on cardButtons, which is an IBOutlet and gets initialized after the view controller itself is initialized. Using lazy ensures that game is only created after cardButtons has been set up, avoiding potential nil references.
    lazy var game = Pairing(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    var emojiChoices = ["🐯", "🐻", "🦊", "🐸", "🦄", "🐶", "🐨", "🐹", "🐤", "🐧", "🐮"]
    var emoji = [Int : String]()
    var flipCount = 0 {
        didSet {
            flipsLabel.text = "Flips: \(flipCount)"
        }
    }
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var lastFlippedCardIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PAIRS GAME"
        
        updateViewFromModel()
    }

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(setEmoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
                button.isEnabled = card.isMatched ? false : true
            }
        }
    }
    
    func setEmoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, !emojiChoices.isEmpty {
            //let randomIndex = Int (arc4random_uniform(UInt32(emojiChoices.count)))
            let randomIndex = Int.random(in: 0..<emojiChoices.count)
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender){
            let result = game.chooseCard(at: cardNumber)
            updateViewFromModel()
            scoreLabel.text = "Score: \(game.score)"
            
            if result == .noMatch || result == .match {
                if let lastFlippedIndex = lastFlippedCardIndex {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                        guard let self = self else { return }
                        self.game.cards[cardNumber].isFaceUp = false
                        self.game.cards[lastFlippedIndex].isFaceUp = false
                        self.updateViewFromModel()
                        self.checkForWin()
                    }
                }
            } else {
                checkForWin()
            }
            if result == .singleCard {
                lastFlippedCardIndex = cardNumber
            }
        } else {
            print("Chosen card is not in cardButtons")
        }
    }
    
    func checkForWin() {
        if game.cards.allSatisfy({ $0.isMatched }) {
            let ac = UIAlertController(title: "You Win!", message: "Congratulations, you've matched\n all the cards!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default) {
                [weak self] action in
                self?.resetGame()
            })
            present(ac, animated: true)
        }
    }
    
    func resetGame() {
        game = Pairing(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        emojiChoices = ["🐯", "🐻", "🦊", "🐸", "🦄", "🐶", "🐨", "🐹", "🐤", "🐧", "🐮", "🐵", "🦁", "🐷", "🐰", "🐼", "🐞", "🦆", "🦋", "🐢", "🦉", "🐍", "🪲"]
        emoji = [Int : String]()
        flipCount = 0
        score = 0
        lastFlippedCardIndex = nil
        updateViewFromModel()
    }
}

