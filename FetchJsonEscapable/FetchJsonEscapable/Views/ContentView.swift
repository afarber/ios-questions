//
//  ContentView.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 02.05.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var vm = TopViewModel()
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TopEntity.elo, ascending: false)],
        animation: .default)
    private var tops: FetchedResults<TopEntity>
    
    var body: some View {
        List {
            ForEach(tops) { top in
                TopRow(top: top)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
