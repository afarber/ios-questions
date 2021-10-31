//
//  ContentView.swift
//  NaviLinkProg
//
//  Created by Alexander Farber on 31.10.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: GameView(gameNumber: 1)
                               /*
                               , isActive: $vm.gameNumber > 0 */) {
                        EmptyView()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
