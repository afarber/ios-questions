import UIKit

var str =
"""
{"data": [{"uid":9844,"elo":2900,"motto":null,"given":"Ольга","avg_time":"04:13","avg_score":20.5},{"uid":13480,"elo":2875,"motto":null,"given":"Наталья","avg_time":"03:27","avg_score":21.0},{"uid":14376,"elo":2825,"motto":null,"given":"Дмитрий","avg_time":"04:51","avg_score":19.8},{"uid":8458,"elo":2734,"motto":null,"given":"Аля","avg_time":"03:03","avg_score":21.1},{"uid":18384,"elo":2723,"motto":null,"given":"Светлана","avg_time":"02:25","avg_score":19.6},{"uid":18125,"elo":2720,"motto":null,"given":"Людмила","avg_time":"03:57","avg_score":20.2},{"uid":14382,"elo":2708,"motto":null,"given":"Виктория","avg_time":"03:33","avg_score":19.1},{"uid":8380,"elo":2687,"motto":null,"given":"Ihor","avg_time":"01:44","avg_score":18.8},{"uid":15917,"elo":2681,"motto":null,"given":"Наталья","avg_time":"04:53","avg_score":20.1},{"uid":19650,"elo":2673,"motto":"Ты не проиграл, пока не сдался.","given":"Елена","avg_time":"01:46","avg_score":18.0},{"uid":13797,"elo":2653,"motto":null,"given":"Irina","avg_time":"03:27","avg_score":19.5},{"uid":13014,"elo":2648,"motto":null,"given":"Светлана","avg_time":"05:32","avg_score":21.6},{"uid":18811,"elo":2634,"motto":null,"given":"Алеся","avg_time":"03:45","avg_score":19.1},{"uid":13455,"elo":2630,"motto":null,"given":"Татьяна","avg_time":"02:43","avg_score":18.1},{"uid":16783,"elo":2614,"motto":null,"given":"Татьяна","avg_time":"02:28","avg_score":18.3}]}
"""

let data = Data(str.utf8)
let json = try? JSONSerialization.jsonObject(with: data, options: [])
guard let jsonDict = json as? [String:Any],
      let dataDict = jsonDict["data"] as? [[String:Any]]
    else { fatalError("Error") }

print(dataDict)
print(dataDict[0]["elo"] ?? 1500)
