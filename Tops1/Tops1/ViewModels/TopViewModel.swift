//
//  TopViewModel.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import Foundation
import Combine

class TopViewModel: ObservableObject {
    
    @Published var tops: [TopModel] = []

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
