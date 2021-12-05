//
//  TransApp.swift
//  TransApp
//
//  Created by Alexander Farber on 05.12.21.
//

import SwiftUI

@main
struct TransApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
