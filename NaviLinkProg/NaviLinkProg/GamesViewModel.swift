//
//  GamesViewModel.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import Foundation

class GamesViewModel: ObservableObject /*, WebSocketDelegate */ {
    @Published var currentGames: [Int] = []
    @Published var displayedGame: Int = 0
    
    func updateCurrentGames() {
        currentGames = currentGames.count == 3 ? [1, 2, 3, 4] : [2, 5, 7]
    }

    func updateDisplayedGame() {
        displayedGame = currentGames.randomElement() ?? 0
    }
}
