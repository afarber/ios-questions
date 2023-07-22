//
//  TopViewModel.swift
//  Tops1
//
//  Created by Alexander Farber on 18.06.21.
//

import Foundation
import Combine
import CoreData

class TopViewModel: NSObject, ObservableObject {

    let urls = [
        "en" : URL(string: "https://wordsbyfarber.com/en/top-all"),
        "de" : URL(string: "https://wordsbyfarber.com/de/top-all"),
        "ru" : URL(string: "https://wordsbyfarber.com/ru/top-all")
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
            .decode(type: TopResponse.self, decoder: JSONDecoder())
            .sink { completion in
                print("fetchTopModels completion=\(completion)")
            } receiveValue: { fetchedTops in
                PersistenceController.shared.container.performBackgroundTask { backgroundContext in
                    backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
                    backgroundContext.automaticallyMergesChangesFromParent = true
                    backgroundContext.perform {
                        for topModel in fetchedTops.data {
                            //print(topModel)
                            let topEntity = TopEntity(context: backgroundContext)
                            topEntity.language = language
                            topEntity.uid = Int32(topModel.id)
                            topEntity.elo = Int32(topModel.elo)
                            topEntity.given = topModel.given
                            topEntity.motto = topModel.motto
                            topEntity.photo = topModel.photo
                            topEntity.avg_score = topModel.avg_score ?? 0.0
                            topEntity.avg_time = topModel.avg_time
                        }
                        if (backgroundContext.hasChanges) {
                            do {
                                try backgroundContext.save()
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
