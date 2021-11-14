//
//  ContentView.swift
//  NaviLinkLocalized
//
//  Created by Alexander Farber on 14.11.21.
//

import SwiftUI

struct ContentView: View {
    let labels = [
        "de": "🇩🇪 DE",
        "en": "🇺🇸 EN",
        "ru": "🇷🇺 RU"
    ]
    
    @AppStorage("language") private var language:String = "en"
    
    @StateObject private var vm:GamesViewModel
    
    init(language: String) {
        _vm = StateObject(wrappedValue: GamesViewModel())
    }
    
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
                    label: { Text("update-games") }
                ).padding(4)

                Button(
                    action: { vm.updateDisplayedGame() },
                    label: { Text("join-random-game") }
                ).padding(4)
            }.navigationTitle("app-title")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                // ! means "this might trap"
                Menu(labels[language]!) {
                    ForEach(labels.sorted(by: <), id: \.key) { key, value in
                        if language == key {
                            Button(
                                action: { },
                                label: { Label(value, systemImage: "checkmark") }
                            )
                        } else {
                            Button(
                                action: { language = key },
                                label: { Text(value) }
                            )
                        }
                    }
                }
            )
        }
        .environmentObject(vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["de", "en", "ru"], id: \.self) { language in
            ContentView(language: language)
                .environment(\.locale, .init(identifier: language))
                .previewLayout(.sizeThatFits)
                .previewDisplayName("locale: \(language)")

        }
    }
}
