//
//  TopViewModel.swift
//  TopsBatchInsert
//
//  Created by Alexander Farber on 06.07.21.
//

import Foundation
import Combine
import CoreData

class TopViewModel: NSObject, ObservableObject {

    let urls = [
        "en" : URL(string: "https://wordsbyfarber.com/ws/top"),
        "de" : URL(string: "https://wortefarbers.de/ws/top"),
        "ru" : URL(string: "https://slova.de/ws/top")
    ]
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var topEntities: [TopEntity] = []

    override init() {
        super.init()
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: "language",
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)

        let language = UserDefaults.standard.string(forKey: "language") ?? "en"
        updateTopEntities(language: language)
        fetchTopModels(language: language)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "language")
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                      of object: Any?,
                      change: [NSKeyValueChangeKey : Any]?,
                      context: UnsafeMutableRawPointer?) {
        guard keyPath == "language",
              let change = change,
              let language = change[.newKey] as? String else {
            return
        }
        updateTopEntities(language: language)
        fetchTopModels(language: language)
    }

    func updateTopEntities(language:String) {
        print("updateTopEntities language=\(language)")
        let viewContext = PersistenceController.shared.container.viewContext
        let request = NSFetchRequest<TopEntity>(entityName: "TopEntity")
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \TopEntity.elo, ascending: false) ]
        request.predicate = NSPredicate(format: "language = %@", language)
        
        do {
            topEntities = try viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func fetchTopModels(language:String) {
        print("fetchTopModels language=\(language)")
        // as? means "this might be nil"
        guard let url = urls[language] as? URL else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleOutput)
            .tryMap { jsonData -> [[String: Any]] in
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                guard let jsonDict = json as? [String: Any],
                      let dataList = jsonDict["data"] as? [[String: Any]]
                    else { throw URLError(.badServerResponse) }
                    return dataList
            }
            // set language on each dataList member
            .map { array in
                array.map { dict -> [String: Any] in
                    var temp = dict
                    temp["language"] = language
                    return temp
                }
            }
            .sink { completion in
                print("fetchTopModels completion=\(completion)")
            } receiveValue: { fetchedTops in
                guard !fetchedTops.isEmpty else { return }

                PersistenceController.shared.container.performBackgroundTask { backgroundContext in
                    backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    backgroundContext.automaticallyMergesChangesFromParent = true
                    backgroundContext.perform {
                        
                        let batchInsert = NSBatchInsertRequest(entity: TopEntity.entity(), objects: fetchedTops)

                        do {
                            try backgroundContext.execute(batchInsert)
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.updateTopEntities(language: language)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200,
            response.statusCode < 300
            else {
                throw URLError(.badServerResponse)
            }
        
        return output.data
    }
}
