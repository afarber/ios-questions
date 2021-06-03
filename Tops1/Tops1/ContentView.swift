//
//  ContentView.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TopEntity.elo, ascending: false)],
        animation: .default)
    private var topEntities: FetchedResults<TopEntity>

    var body: some View {
        List {
            ForEach(topEntities) { top in
                Text(top.given ?? "Unknown person")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
