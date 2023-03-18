//
//  Set_GameApp.swift
//  Set Game
//
//  Created by Deni Tusha on 2/26/23.
//

import SwiftUI

@main
struct Set_GameApp: App {
    private let game = SetCardGame()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
