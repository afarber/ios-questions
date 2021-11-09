import UIKit
import Foundation

let decoder = JSONDecoder()

struct MovesResponse: Codable {
    let moves: [MoveModel]
}

struct MoveModel: Codable {
    let mine: Int
    let words: String
    let letters: String
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        mine = try container.decode(Int.self)
        words = try container.decode(String.self)
        letters = try container.decode(String.self)
    }
}

let jsonMoves:String =

"""
 { "moves":
     [
         [0, "CAT (7)", "ACT"],
         [1, "EXTRA (14)", "ERXT"],
         [0, "TOP (22)", "PO"],
         [1, "TOY (9)", "Y"]
     ]
  }
"""

if let movesData = jsonMoves.data(using: .utf8),
    let movesResponse = try? decoder.decode(MovesResponse.self, from: movesData),
   movesResponse.moves.count > 0,
   movesResponse.moves[0].letters.count > 0
{
    print("Parsed moves: ", movesResponse)
} else {
    print("Can not parse moves")
}

let jsonChat:String =

"""
{ "chat": [ [1, "Hi"], [0, "Hello"] ] }
"""

struct ChatResponse: Codable {
    let chat: [ChatModel]
}

struct ChatModel: Codable {
    let mine: Int
    let msg: String
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        mine = try container.decode(Int.self)
        msg = try container.decode(String.self)
    }
}

if let chatData = jsonChat.data(using: .utf8),
    let chatResponse = try? decoder.decode(ChatResponse.self, from: chatData),
   chatResponse.chat.count > 0,
   chatResponse.chat[0].msg.count > 0
{
    print("Parsed chat: ", chatResponse)
} else {
    print("Can not parse chat")
}

enum Social: Int, Decodable, Encodable {
    case
        UNKNOWN       = 0,
        GOOGLE        = 1,
        APPLE         = 2,
        ODNOKLASSNIKI = 4,
        MAILRU        = 8,
        VKONTAKTE     = 16,
        FACEBOOK      = 32,
        AMAZON        = 64,
        HUAWEI        = 128
}

struct LoginModel: Codable {
    let gid:Int             // always 0
    let social:Social
    let auth:String
    let sid:String
    let action:String       // always "login"
    let users:[UserModel]
}

struct UserModel: Codable {
    let social:Social
    let sid:String
    let auth:String
    let given:String
    let family:String?
    let photo:String?
    let stamp:Int
}

let jsonLogin:String? =
"""
{"gid":0,"social":4,"auth":"abcde","action":"login","sid":"12345","users":[
{"given":"Alex","social":4,"auth":"abcde","photo":"https://i.mycdn.me/image?id=890737171808&t=0&plc=API&ts=00&aid=1158060544&tkn=*gw3Aym63uOOyl7-aBylAfUYE6xU","stamp":1635577644,"family":"Farber","sid":"12345"},
{"given":"Alexander","social":1,"auth":"xyzok","photo":"https://lh3.googleusercontent.com/a-/AOh14GgqDXvSLH3hgFH_6Y9spW6bBBSjVGHQg5X6k3cue2k=s96-c","stamp":1635533473,"family":"Farber","sid":"67890"}
]}
"""

if let loginData = jsonLogin?.data(using: .utf8),
   let loginModel = try? decoder.decode(LoginModel.self, from: loginData),
    loginModel.gid == 0,
    loginModel.action == "login"
{
    print("Parsed users: ", loginModel.users)
} else {
    print("Can not parse users")
}

struct GameModel: Codable, Identifiable {
    var id: Int { gid }
    let gid: Int
    let bid: Int        // board id: can be 0, 1, 2 or 3
    let created: Int
    let finished: Int?
    let letters: [[String?]]
    let values: [[Int?]]
    let pilelen: Int
    let tiles: [TileModel]
    
    let score: Int
    let player1: Int
    let player2: Int?
    let score1: Int
    let score2: Int
    let diff1: Int?
    let diff2: Int?
    let open1: Bool
    let state1: String
    let hint1: String
    let chat1: Int
    let elo1: Int
    let elo2: Int?
    let motto2: String?
    let avg_score2: Double?
    let avg_time2: String?
    let lat2: Double?
    let lng2: Double?
    let given1: String
    let given2: String?
    let photo1: String?
    let photo2: String?
    let played1: Int
    let played2: Int?
    let hand1: String
    let left1: Int?
    let left2: Int?
}

struct TileModel: Codable {
    let col: Int
    let row: Int
    let value: Int
    let letter: String
}

let jsonGames:String? =
"""
[
{"gid":266,"created":1632249990,"finished":null,"letters":[
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,"H",null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,"U",null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,"E",null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]],
"values":[
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,4,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,1,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,1,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]],
"bid":1,"pilelen":83,
"tiles":[
{"col": 8, "row": 7, "value": 1, "letter": "E"},
{"col": 7, "row": 7, "value": 1, "letter": "U"},
{"col": 6, "row": 7, "value": 4, "letter": "H"}
],
"score":6,"player1":5,"player2":null,
"score1":6,"score2":0,
"diff1":null,"diff2":null,
"open1":false,"state1":"winning",
"hint1":"Score 6:0. It is opponent's turn.",
"chat1":0,
"elo1":1926,"elo2":null,
"motto2":null,"avg_time2":null,"avg_score2":null,
"lat2":null,"lng2":null,
"given1":"Apple 001084",
"given2":null,
"photo1":null,"photo2":null,
"played1":1634033539,"played2":null,
"hand1":"IAIOYTI","left1":null,"left2":null}
]
"""

if let gamesData = jsonGames?.data(using: .utf8),
   let gamesModel = try? decoder.decode([GameModel].self, from: gamesData),
    gamesModel[0].gid > 0
{
    print("Parsed games: ", gamesModel)
} else {
    print("Can not parse games")
}

