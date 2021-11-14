//
//  NaviLinkLocalizedApp.swift
//  NaviLinkLocalized
//
//  Created by Alexander Farber on 14.11.21.
//

import SwiftUI

@main
struct NaviLinkLocalizedApp: App {
    @AppStorage("language") var language:String = "en"

    var body: some Scene {
        WindowGroup {
            ContentView(language: language)
                .environment(\.locale, .init(identifier: language))
        }
    }
}
