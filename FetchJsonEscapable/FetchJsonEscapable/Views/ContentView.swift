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
        sortDescriptors: [NSSortDescriptor(keyPath: \TopEntity.elo, ascending: true)],
        animation: .default)
    private var tops: FetchedResults<TopEntity>
    
    var body: some View {
        List {
            ForEach(tops) { top in
                TopRow(top: top)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tops[$0] }.forEach(moc.delete)
            
            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
