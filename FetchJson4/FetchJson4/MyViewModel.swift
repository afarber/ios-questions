//
//  MyViewModel.swift
//  FetchJson4
//
//  Created by Alexander Farber on 30.04.21.
//

import Foundation

struct TopResponse: Codable {
    let data: [Top]
}

struct Top: Codable {
    let uid: Int
    let elo: Int
    let given: String
    let photo: String?
    let motto: String?
    let avg_score: Double?
    let avg_time: String?
}

class MyViewModel: ObservableObject {
    @Published var items:[String]

    init() {
        items = (1...4).map { number in "Item \(number)" }
    }
    
    func updateItems() {
        let url = URL(string: "https://slova.de/ws/top")!
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            let decoder = JSONDecoder()
            guard let data = data else { return }
            do {
                let tops = try decoder.decode(TopResponse.self, from: data)
                for (index, top) in tops.data.enumerated() {
                    let str = "\(index + 1): \(top.given)"
                    print(str)
                    DispatchQueue.main.async {
                        self.items.append(str)
                    }
                }
            } catch {
                print("Error while parsing: \(error)")
            }
        }
        task.resume()
    }
}
