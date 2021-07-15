//
//  TopViewModel.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//

import Foundation
import Combine
import CoreData

class TopViewModel: NSObject, ObservableObject {

    let urls = [
        "en": URL(string: "https://wordsbyfarber.com/ws/top"),
        "de": URL(string: "https://wortefarbers.de/ws/top"),
        "ru": URL(string: "https://slova.de/ws/top")
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
        guard let container = PersistenceController.shared[language]?.container else { return }
        let request = NSFetchRequest<TopEntity>(entityName: "TopEntity")
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \TopEntity.elo, ascending: false) ]
        
        do {
            topEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func fetchTopModels(language:String) {
        print("fetchTopModels language=\(language)")
        // as? means "this might be nil"
        guard let url = urls[language] as? URL,
              let container = PersistenceController.shared[language]?.container
            else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleOutput)
            .decode(type: TopResponse.self, decoder: JSONDecoder())
            .sink { completion in
                print("fetchTopModels completion=\(completion)")
            } receiveValue: { fetchedTops in
                guard !fetchedTops.data.isEmpty else { return }

                container.performBackgroundTask { backgroundContext in
                    backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    backgroundContext.automaticallyMergesChangesFromParent = true
                    backgroundContext.perform {

                        var index = 0
                        let batchInsert = NSBatchInsertRequest(
                            entity: TopEntity.entity()) { (managedObject: NSManagedObject) -> Bool in

                            // return true to complete creating the batch insert request
                            guard index < fetchedTops.data.count else { return true }

                            if let topEntity = managedObject as? TopEntity {
                                let topModel = fetchedTops.data[index]

                                topEntity.uid = Int32(topModel.id)
                                topEntity.elo = Int32(topModel.elo)
                                topEntity.given = topModel.given
                                topEntity.motto = topModel.motto
                                topEntity.photo = topModel.photo
                                topEntity.avg_score = topModel.avg_score ?? 0.0
                                topEntity.avg_time = topModel.avg_time
                            }

                            index += 1
                            // return false to continue creating the batch insert request
                            return false
                        }

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
