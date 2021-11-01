//
//  GamesViewModel.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import Foundation
import SwiftUI

class GamesViewModel: ObservableObject /*, WebSocketDelegate */ {
    @Published var currentGames: [Int] = [2, 3]
    @Published var displayedGame: Int?
    
    func navigationBinding(gameNumber: Int) -> Binding<Bool> {
        .init {
            self.displayedGame == gameNumber
        } set: { newValue in
            self.displayedGame = newValue ? gameNumber : nil
        }
    }
    
    func updateCurrentGames() {
        currentGames = currentGames.count == 3 ? [1, 2, 3, 4] : [2, 5, 7]
    }

    func updateDisplayedGame() {
        displayedGame = currentGames.randomElement() ?? 0
    }
}
