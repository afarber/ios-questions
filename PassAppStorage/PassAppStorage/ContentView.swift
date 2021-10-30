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

    @StateObject var vm:MyViewModel

    init(language: String) {
        _vm = StateObject(wrappedValue: MyViewModel(language: language))
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(language: "en")
    }
}
