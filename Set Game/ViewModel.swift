//
//  ViewModel.swift
//  Set Game
//
//  Created by Deni Tusha on 2/27/23.
//e

import SwiftUI

class SetCardGame: ObservableObject{
    typealias Card = CardGame<SetCardContent>.Card
    @Published public var model: CardGame<SetCardContent>
    
    var numberOfSelectedCards: Int{
        return model.numOfSelectedCards
    }
    
    var selectedCards: Array<Int> {
        return model.selectedIndices
    }
    
    var cards: Array<Card>{
        return model.cards
    }
    
    var deck: Array<Card>{
        return model.Deck
    }
    func newGame(){
        model = CardGame<SetCardContent>(arrayOfCardContent: Deck.shuffled())
    }
    
    private static func createSetGame() -> CardGame<SetCardContent> {
        return CardGame<SetCardContent>(arrayOfCardContent: Deck)
    }
    
    init() {
        model = SetCardGame.createSetGame()
    }
    
    func deal3More(){
        model.deal3More()
    }
    func match(_ card: Card) {
        model.match(card: card)
    }
}
