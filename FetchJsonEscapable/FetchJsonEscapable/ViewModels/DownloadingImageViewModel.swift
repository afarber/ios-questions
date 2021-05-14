//
//  TopImageViewModel.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import Foundation
import SwiftUI
import Combine

class DownloadingImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    let manager = CacheManager.instance
    
    let urlString: String
    
    init(url: String) {
        urlString = url
        getImage()
    }
    
    func getImage() {
        if let savedImage = manager.get(name: urlString) {
            image = savedImage
            print("Getting saved image!")
        } else {
            downloadImage()
            print("Downloading image now!")
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
                self.manager.add(image: image, name: self.urlString)
            }
            .store(in: &cancellables)
    }
}
