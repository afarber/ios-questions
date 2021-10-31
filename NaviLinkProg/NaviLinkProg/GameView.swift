//
//  GameView.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import SwiftUI

struct GameView: View {
    private var gameNumber:Int
    
    init(gameNumber: Int) {
        self.gameNumber = gameNumber
    }

    var body: some View {
        Text("Game #\(gameNumber)")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(gameNumber: 42)
    }
}
