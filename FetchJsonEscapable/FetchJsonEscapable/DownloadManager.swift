//
//  DownloadManager.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import Foundation
import Combine

class DownloadManager {
    static let instance = DownloadManager()
    
    @Published var tops: [Top] = []
    var cancellables = Set<AnyCancellable>()
    
    private init() {
        getTopsCombine()
        //getTopsEscapable()
    }
    
    func getTopsCombine() {
        guard let url = URL(string: "https://slova.de/ws/top") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: TopResponse.self, decoder: JSONDecoder())
            .sink{ ( completion ) in
                print(completion)
            } receiveValue: { [weak self] (returnedTops) in
                self?.tops = returnedTops.data
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
    
    func getTopsEscapable() {
        guard let url = URL(string: "https://slova.de/ws/top") else { return }

        downloadData(fromURL: url) { (returnedData) in
            if let data = returnedData {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(TopResponse.self, from: data)
                    print(response.data[4].given)
                    DispatchQueue.main.async { [weak self] in
                        self?.tops = response.data
                    }
                } catch {
                    print("Error while parsing: \(error)")
                }
            }
        }
    }
    
    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error")
                completionHandler(nil)
                return
            }
            
            completionHandler(data)
        }.resume()
    }
}
