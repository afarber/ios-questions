//
//  TopViewModel.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import Foundation
import Combine

class TopViewModel: ObservableObject {
    
    @Published var tops: [Top] = []

    let cacheManager = CacheManager.instance
    let downloadManager = DownloadManager.instance
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        downloadManager.$tops
            .sink { [weak self] (returnedTops) in
                self?.tops = returnedTops
            }
            .store(in: &cancellables)
    }
}
