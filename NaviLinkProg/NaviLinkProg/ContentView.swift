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
        NavigationView {
            VStack {
                
                // the NavigationLink/EmptyView should stay visible onscreen for the isActive to work
                NavigationLink(
                        destination: GameView(gameNumber: vm.displayedGame),
                        isActive: vm.navigationBinding()
                ) {
                    EmptyView()
                }
                
                // iOS 15 feature: create a List from binding
                List($vm.currentGames, id: \.self) { $gameNumber in
                    NavigationLink(
                            destination: GameView(gameNumber: gameNumber)
                        ) {
                        Text("Game #\(gameNumber)")
                    }
                }
                Button(
                    action: { vm.updateCurrentGames() },
                    label: { Text("Update games") }
                ).padding(4)

                Button(
                    action: { vm.updateDisplayedGame() },
                    label: { Text("Join a random game") }
                ).padding(4)
          }.navigationBarTitle("Select a game")
       }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
