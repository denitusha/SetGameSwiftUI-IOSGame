//
//  SetCard.swift
//  Set Game
//
//  Created by Deni Tusha on 2/26/23.
//

import SwiftUI

protocol Matchable {
   
    static func areCardsSet(_ card1: Any, _ card2: Any, _ card3: Any) -> Bool
}

struct SetCardContent: Hashable{
    let color: ColorValue
    let shape: Shape
    let shading: Shading
    let number: Int
    
    enum ColorValue:  CaseIterable, Hashable{
        case  red
        case green
        case purple
        
        var colorValue: Color{
            switch self {
            case .red:
                return Color.red
            case .green:
                return Color.green
            case .purple:
                return Color.purple
            }
        }
    }
    
    enum Shape:  CaseIterable, Hashable {
        case diamond
        case rectangle
        case oval
    }
    
    enum Shading: CaseIterable, Hashable {
        case solid
        case striped
        case open
        
        var opacityValue: Double {
            switch self {
            case .solid:
                return 1.0
            case .striped:
                return 0.5
            case .open:
                return 0.0
            }
        }
    }
}

extension SetCardContent: Matchable {
    static func areCardsSet(_ card1: Any, _ card2: Any, _ card3: Any) -> Bool {
        guard let card1 = card1 as? SetCardContent,
              let card2 = card2 as? SetCardContent,
              let card3 = card3 as? SetCardContent
        else {
            return false
        }
        
        let colorSet = Set([card1.color, card2.color, card3.color])
        let shapeSet = Set([card1.shape, card2.shape, card3.shape])
        let shadingSet = Set([card1.shading, card2.shading, card3.shading])
        let numberSet = Set([card1.number, card2.number, card3.number])
        
        return (colorSet.count == 2 || shapeSet.count == 2 ||
                shadingSet.count == 2 || numberSet.count == 2) ? false : true
    }
}

func createCards() -> [SetCardContent] {
    var cards = [SetCardContent]()
    
    for color in SetCardContent.ColorValue.allCases {
        for shape in SetCardContent.Shape.allCases {
            for shading in SetCardContent.Shading.allCases {
                for number in 1...3 {
                    let card = SetCardContent(color: color, shape: shape, shading: shading, number: number)
                    cards.append(card)
                }
            }
        }
    }
    
    return cards
}



func createSmallDeck() -> [SetCardContent] {
    var smallDeck: [SetCardContent] = []
    var selectedCards: Set<SetCardContent> = []
    
    for i in 0..<24 {
        var card = Deck[i]
        while selectedCards.contains(card) {
            card = Deck.randomElement()!
        }
        selectedCards.insert(card)
        smallDeck.append(card)
    }
    
    return smallDeck
}



let Deck: [SetCardContent] = createCards().shuffled()
let smallDeck = createSmallDeck()


