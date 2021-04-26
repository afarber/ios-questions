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
    let results: [Top]
}
struct Top: Codable {
    let uid: Int
    let elo: Int
    let given: String
    let photo: String?
    let motto: String?
    let avg_score: String?
    let avg_time: String?
}

let url = URL(string: "https://slova.de/ws/top")!
let task = URLSession.shared.dataTask(with: url) {
    data, response, error in
    
    guard let data1 = data, let json = try? JSONSerialization.jsonObject(with: data1, options: [])
    else { return }
    print(json)
    
    let decoder = JSONDecoder()
    guard let data2 = data,
          let tops = try? decoder.decode(TopResponse.self, from:
                                            data2) else { return }
    print(tops.results[4].given)
}
task.resume()

PlaygroundPage.current.setLiveView(FetchView1().padding(5))
