//
//  GamesViewModel.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import Foundation
import SwiftUI

class GamesViewModel: ObservableObject /*, WebSocketDelegate */ {
    @Published var currentGames: [Int] = [20, 30]
    @Published var displayedGame: Int = 0
    
    func navigationBinding() -> Binding<Bool> {
        .init {
            self.displayedGame > 0
        } set: { newValue in
            self.displayedGame = 0
        }
    }
    
    func updateCurrentGames() {
        currentGames = currentGames.count == 3 ? Array(10...50) : [20, 50, 70]
    }

    func updateDisplayedGame() {
        displayedGame = currentGames.randomElement() ?? 0
    }
}
