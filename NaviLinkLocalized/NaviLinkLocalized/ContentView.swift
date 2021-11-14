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
        "fr": "🇫🇷 FR",
        "nl": "🇳🇱 NL",
        "pl": "🇵🇱 PL",
        "ru": "🇷🇺 RU"
    ]
    
    @AppStorage("language") private var language:String = "en"
    
    @StateObject private var vm:GamesViewModel
    
    init(language: String) {
        _vm = StateObject(wrappedValue: GamesViewModel())
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
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
