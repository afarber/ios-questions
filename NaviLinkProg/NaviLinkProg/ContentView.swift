//
//  ContentView.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm:GamesViewModel = GamesViewModel()

    var body: some View {
        VStack {
            List {
                ForEach((1...10).reversed(), id: \.self) { gameNumber in
                    NavigationLink(destination: GameView(gameNumber: gameNumber)) {
                        Text("Game #\(gameNumber)")
                    }
                }
            }

            Button(
                action: { vm.updateDisplayedGame() },
                label: { Text("Join a random game") }
            )
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
