//
//  Tops1App.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import SwiftUI

@main
struct Tops1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
