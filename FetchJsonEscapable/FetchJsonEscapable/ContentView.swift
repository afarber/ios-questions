//
//  ContentView.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 02.05.21.
//

import SwiftUI
import CoreData

struct TopResponse: Codable {
    let data: [Top]
}

struct Top: Codable, Identifiable {
    var id: Int { uid }
    let uid: Int
    let elo: Int
    let given: String
    let photo: String?
    let motto: String?
    let avg_score: Double?
    let avg_time: String?
}

class MyViewModel: ObservableObject {
    
    let manager = CacheManager.instance
    
    @Published var tops: [Top] = []
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://slova.de/ws/top") else { return }

        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(TopResponse.self, from: data)
                    print(response.data[4].given)
                    DispatchQueue.main.async { [weak self] in
                        self?.tops = response.data
                    }
                } catch {
                    print("Error while parsing: \(error)")
                }
            }
        }
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error")
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
        }.resume()
    }
}

struct ContentView: View {
    @StateObject var vm = MyViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
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
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
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
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
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
