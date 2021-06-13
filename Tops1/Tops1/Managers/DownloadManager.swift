//
//  DownloadManager.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import Foundation
import Combine
import CoreData

class DownloadManager {
    static let instance = DownloadManager()
    
    let urls = [
        "en" : URL(string: "https://wordsbyfarber.com/ws/top"),
        "de" : URL(string: "https://wortefarbers.de/ws/top"),
        "ru" : URL(string: "https://slova.de/ws/top")
    ]
    
    var cancellables = Set<AnyCancellable>()

    private init() {
        getTops()
    }
    
    func getTops() {
        guard let url = urls["en"] else { return }
        
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
                            topEntity.uid = Int32(topModel.id)
                            topEntity.elo = Int32(topModel.elo)
                            topEntity.given = topModel.given
                            topEntity.motto = topModel.motto
                            topEntity.photo = topModel.photo
                            topEntity.avg_score = topModel.avg_score ?? 0.0
                            topEntity.avg_time = topModel.avg_time
                        }
                        do {
                            try backgroundContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
