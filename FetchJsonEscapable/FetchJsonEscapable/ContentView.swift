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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
        
    var body: some View {
        NavigationView {
            VStack {
                Text("FetchJsonEscapable").foregroundColor(.orange)
                List {
                    ForEach(vm.tops) { top in
                        VStack {
                            Text(top.given)
                            
                            HStack {
                                Text(String(top.elo))
                                Text(top.avg_time ?? "")
                                Text(String(top.avg_score ?? 0))
                            }
                        }
                    }
                    /*
                    ForEach(items) { item in
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    .onDelete(perform: deleteItems)
                     */
                }
                .toolbar {
                    /*
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        EditButton()
                    }
                    #endif
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    */
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: moc)
            newItem.timestamp = Date()
            
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
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(moc.delete)
            
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
