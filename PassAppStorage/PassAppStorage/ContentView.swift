//
//  ContentView.swift
//  PassAppStorage
//
//  Created by Alexander Farber on 24.10.21.
//

import SwiftUI

struct ContentView: View {
    let labels = [
        "de": "🇩🇪 DE",
        "en": "🇺🇸 EN",
        "fr": "🇫🇷 FR",
        "nl": "🇳🇱 NL",
        "pl": "🇵🇱 PL",
        "ru": "🇷🇺 RU"
    ]
    
    @AppStorage("language") var language:String = "en"

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
