import Foundation
import PlaygroundSupport
import SwiftUI

struct FetchView1: View {
    
    @State private var rotation: Double = 0
    
    var body: some View {
        
        VStack {
            Rectangle()
                .fill(Color.blue)
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(rotation))
                .animation(.linear)
            Button("Button1", action: {
                rotation = (rotation < 360 ? rotation + 60 : 0)
            })
            Text("Rotate me")
        }
        .padding(10)
    }
}

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

let url = URL(string: "https://slova.de/ws/top")!
let task = URLSession.shared.dataTask(with: url) {
    data, response, error in
    
    let decoder = JSONDecoder()
    guard let data = data else { return }
    do {
        let tops = try decoder.decode(TopResponse.self, from: data)
        print(tops.data[4].given)
    } catch {
        print("Error while parsing: \(error)")
        print("the data: \(String(data: data, encoding: .utf8))")
    }
}
task.resume()

PlaygroundPage.current.setLiveView(FetchView1().padding(5))
