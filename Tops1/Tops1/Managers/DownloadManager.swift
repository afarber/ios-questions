//
//  DownloadManager.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import Foundation
import Combine

class DownloadManager {
    static let instance = DownloadManager()
    
    var cancellables = Set<AnyCancellable>()
    let viewContext = PersistenceController.shared.container.viewContext;
    
    private init() {
        getTops()
    }
    
    func getTops() {
        guard let url = URL(string: "https://slova.de/ws/top") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: TopResponse.self, decoder: JSONDecoder())
            .sink{ completion in
                print(completion)
            } receiveValue: { [weak self] returnedTops in
                for top in returnedTops.data {
                    print(top)
                    let topEntity = TopEntity(context: PersistenceController.shared.container.viewContext)
                    topEntity.uid = Int32(top.id)
                    topEntity.elo = Int32(top.elo)
                    topEntity.given = top.given
                    topEntity.motto = top.motto
                    topEntity.photo = top.photo
                    topEntity.avg_score = top.avg_score ?? 0.0
                    topEntity.avg_time = top.avg_time
                }
                self?.save()
            }
            .store(in: &cancellables)
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
