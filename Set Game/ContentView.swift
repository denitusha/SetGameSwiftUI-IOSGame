//
//  ContentView.swift
//  Set Game
//
//  Created by Deni Tusha on 2/26/23.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var game: SetCardGame
    init(game: SetCardGame) {
        self.game = game
        UIScrollView.appearance().bounces = true
    }
    
    var body: some View {
        ZStack {
            Color("backroundColor")
                .brightness(-0.25)
                .ignoresSafeArea()
            VStack {
                HStack{
                    Button {
                        game.deal3More()
                    }label: {
                        Text("Deal 3 more")
                            .foregroundColor(.black)
                    }
                    .disabled(game.deck.isEmpty)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color("button"))
                    )
                    Spacer()
                    Text("Cards left in deck: \(game.deck.count)")
                        .font(.headline)
                        .bold(true)
                    Spacer()
                    Button {
                        game.newGame()
                    } label: {
                        Text("New Game")
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .circular)
                            .fill(Color("button"))
                    )
                }
                    .padding(.horizontal, 10)
                Spacer()
                if game.cards.count <= 18 {
                    AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                        CardView(card: card, game: game)
                            .padding(5)
                            .onTapGesture {
                                game.match(card)
                            }
                    })
                } else {
                    ScrollView(.vertical) {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 85))]) {
                                ForEach(game.cards) { card in
                                    CardView(card: card, game: game)
                                        .aspectRatio(2/3, contentMode: .fit)
                                        .padding(1.5)
                                        .onTapGesture {
                                            game.match(card)
                                        }
                                }
                            }
                            .padding(3)
                        }

                    }
                    
                    
                    
                }
            }
        }
    }
 }
               
        


struct CardView: View {
    let card: SetCardGame.Card
    let game: SetCardGame
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 8)
                    .foregroundColor(getColorOfBorder(game: game, card: card))
                RoundedRectangle(cornerRadius: 5)
                    .fill(.white)
                VStack(spacing: 6) {
                    ForEach(0..<card.content.number, id: \.self) { _ in
                        switch card.content.shape {
                        case .diamond:
                            if card.content.shading == .open {
                                Diamond()
                                    .stroke(card.content.color.colorValue, lineWidth: 3)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                            } else {
                                Diamond()
                                    .fill(card.content.color.colorValue)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                                    .opacity(card.content.shading.opacityValue)
                            }
                        case .rectangle:
                            if card.content.shading == .open {
                                Rectangle()
                                    .stroke(card.content.color.colorValue, lineWidth: 3)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                            } else {
                                Rectangle()
                                    .fill(card.content.color.colorValue)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                                    .opacity(card.content.shading.opacityValue)
                            }
                        case .oval:
                            if card.content.shading == .open {
                                Capsule()
                                    .stroke(card.content.color.colorValue, lineWidth: 3)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                            } else {
                                Capsule()
                                    .fill(card.content.color.colorValue)
                                    .frame(width: shapeSize(geometry), height: shapeSize(geometry) / 2)
                                    .opacity(card.content.shading.opacityValue)
                            }
                        }
                    }
                }
                .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    
    func shapeSize(_ geometry: GeometryProxy) -> CGFloat {
        return min(geometry.size.width, geometry.size.height) * 0.8
    }
    
    func getColorOfBorder(game : SetCardGame, card: SetCardGame.Card) -> Color{
        if  game.numberOfSelectedCards == 3 {
            if  card.isMatched {
                return Color.purple
            } else if card.isSelected {
                return Color.red
            }else if game.selectedCards.contains(card.id) {
                return Color.red
            } else {
                return Color.black
            }
        }else {
            if card.isSelected{
                return Color.blue
            }else {
                return Color.black
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetCardGame()
        ContentView(game: game )
    }
}
