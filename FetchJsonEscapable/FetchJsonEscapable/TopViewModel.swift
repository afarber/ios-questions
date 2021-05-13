//
//  TopViewModel.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import Foundation
import Combine

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

class TopViewModel: ObservableObject {
    
    let cacheManager = CacheManager.instance
    let downloadManager = DownloadManager.instance
    
    var cancellables = Set<AnyCancellable>()
    @Published var tops: [Top] = []
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        downloadManager.$tops
            .sink { [weak self] (returnedTopModels) in
                self?.tops = returnedTopModels
            }
            .store(in: &cancellables)
    }
}
