//
//  Model.swift
//  Set Game
//
//  Created by Deni Tusha on 2/27/23.
//

import Foundation

struct CardGame <CardContent> where CardContent: Matchable {
    private(set) var Deck: Array<Card>
    private(set) var cards: [Card]
    var numOfSelectedCards: Int {
        get{ cards.indices.filter({cards[$0].isSelected}).count}
    }
    var selectedIndices: [Int] {cards.indices.filter {cards[$0].isSelected}}
    var matchedIndices: [Int] {
            cards.indices.filter { cards[$0].isSelected && cards[$0].isMatched } }
    
    
    
    mutating func match(card: Card){
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id }),
           !cards[chosenIndex].isSelected,
           !cards[chosenIndex].isMatched {
            if selectedIndices.count == 2 {
                //This is the third selected card
                cards[chosenIndex].isSelected = true
                let selectedCardContents = selectedIndices.map { cards[$0].content }
                if CardContent.areCardsSet(selectedCardContents[0], selectedCardContents[1], selectedCardContents[2]) {
                    // The cards match
                    
                    for index in selectedIndices {
                        cards[index].isMatched = true
                    }
                }else{
                    for index in selectedIndices {
                        cards[index].isNotMatched = true
                    }
                }
            }else {
                // there is the first second or 4th
                if selectedIndices.count == 1 || selectedIndices.count == 0  {
                    // its the first or second
                    cards[chosenIndex].isSelected = true
                }else if cards[selectedIndices[0]].isMatched{
                    // its the 4th and there is a match
                    cards[chosenIndex].isSelected = true
                    changeCards()
                    for index in cards.indices{
                        if index == chosenIndex{
                            continue
                        }
                        cards[index].isSelected = false
                    }
                }else {
                    cards[chosenIndex].isSelected = true
                    //its the forth and there is no match
                    for index in cards.indices{
                        if index == chosenIndex{
                            continue
                        }
                        cards[index].isSelected = false
                        cards[index].isNotMatched = false
                    }
                }
            }
        }else if let chosenIndex = cards.firstIndex(where: {$0.id == card.id }),
            cards[chosenIndex].isSelected,
            !cards[chosenIndex].isMatched,
            !cards[chosenIndex].isNotMatched{
            cards[chosenIndex].isSelected = false
        }
        
    }
    

    mutating func changeCards() {
           guard matchedIndices.count == 3 else { return }
           let replaceIndices = matchedIndices
           if  Deck.count >= 3 && cards.count == 12{
               //------------- Replace matched cards--------------
               for index in replaceIndices {
                   cards.remove(at: index)
                   cards.insert(Deck.remove(at: 0), at: index)
               }
           } else  {
               //------------- Remove matched cards--------------
               cards = cards.enumerated()
               .filter { !replaceIndices.contains($0.offset) }
               .map { $0.element }
           }
       }

    mutating func deal() {
        guard Deck.count >= 12 else { return }
        cards += Deck.prefix(12)
        Deck.removeFirst(12)
    }

    mutating func deal3More(){
        if Deck.count >= 3{
            for index in 0...2 {
                cards.append(Deck[index])
            }
            Deck.removeFirst(3)
        }
    }
    

    struct Card : Identifiable{
        var id: Int
        var content: CardContent
        var isSelected = false
        var isMatched = false
        var isOut = false
        var isNotMatched: Bool = false
    }
    
    init(arrayOfCardContent: [CardContent]) {
        Deck = []
        cards = []
        var index: Int = 0
        for card in arrayOfCardContent {
            Deck.append(Card(id: index , content: card))
            index += 1
        }
        deal()
    }
    
}
