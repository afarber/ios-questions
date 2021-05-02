//
//  FetchJsonEscapableApp.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 02.05.21.
//

import SwiftUI

@main
struct FetchJsonEscapableApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
