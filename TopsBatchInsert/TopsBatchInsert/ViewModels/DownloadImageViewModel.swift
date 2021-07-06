//
//  DownloadImageViewModel.swift
//  TopsBatchInsert
//
//  Created by Alexander Farber on 06.07.21.
//

import Foundation
import SwiftUI
import Combine

class DownloadImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let cacheManager = CacheManager.instance
    
    let urlString: String
    
    init(url: String) {
        urlString = url
        getImage()
    }
    
    func getImage() {
        if let savedImage = cacheManager.get(name: urlString) {
            image = savedImage
            print("Image found in cache")
        } else {
            downloadImage()
            print("Downloading image...")
        }
    }
    
    func downloadImage() {
        isLoading = true
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                guard
                    let self = self,
                    let image = returnedImage else { return }
                
                self.image = image
                self.cacheManager.add(image: image, name: self.urlString)
            }
            .store(in: &cancellables)
    }
}
