//
//  TopViewModel.swift
//  Tops1
//
//  Created by Alexander Farber on 18.06.21.
//

import Foundation
import Combine
import CoreData

class TopViewModel: ObservableObject {
    let urls = [
        "en" : URL(string: "https://wordsbyfarber.com/ws/top"),
        "de" : URL(string: "https://wortefarbers.de/ws/top"),
        "ru" : URL(string: "https://slova.de/ws/top")
    ]
    
    var cancellables = Set<AnyCancellable>()
    
    // get language string from UserDefault (but how to observe it?)
    var language = UserDefaults.standard.string(forKey: "language") ?? "en"

    @Published var topEntities: [TopEntity] = []

    init() {
        updateTopEntities()
        fetchTopModels(language: language)
    }

    func updateTopEntities() {
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
        // as? means "this might be nil"
        guard let url = urls[language] as? URL else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleOutput)
            .decode(type: TopResponse.self, decoder: JSONDecoder())
            .sink { completion in
                print(completion)
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
                                self?.updateTopEntities()
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
            response.statusCode >= 200 && response.statusCode < 300
            else {
                throw URLError(.badServerResponse)
            }
        
        return output.data
    }

}
