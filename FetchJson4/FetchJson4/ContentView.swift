import SwiftUI

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

struct ContentView: View {
    var items:[String];

    init() {
        items = (1...200).map { number in "Item \(number)" }
        
        let url = URL(string: "https://slova.de/ws/top")!
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            let decoder = JSONDecoder()
            guard let data = data else { return }
            //print(String(describing: String(data: data, encoding: .utf8)))
            do {
                let tops = try decoder.decode(TopResponse.self, from: data)
                print(tops.data[4].given)
                for (index, top) in tops.data.enumerated() {
                    let str = "\(index + 1): \(top.given)"
                    print(str)
                    //items.append(str)
                }
            } catch {
                print("Error while parsing: \(error)")
            }
        }
        task.resume()
    }

    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
        .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
