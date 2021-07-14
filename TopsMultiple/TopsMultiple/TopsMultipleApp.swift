//
//  TopsMultipleApp.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//

import SwiftUI

@main
struct TopsMultipleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
