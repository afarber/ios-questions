import UIKit
import Foundation

enum Social: Int, Decodable {
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
    let social:Int
    let auth:String
    let sid:String
    let action:String       // always "login"
    let users:[UserModel]
}

struct UserModel: Codable {
    let social:Int
    let sid:String
    let auth:String
    let given:String
    let family:String?
    let photo:String?
    let stamp:Int
}

let jsonLogin:String? =
"""
{"gid":0,"social":4,"auth":"abcde","action":"login","sid":"12345",
"users":[{"given":"Alex","social":4,"auth":"abcde",
"photo":"https://i.mycdn.me/image?id=890737171808&t=0&plc=API&ts=00&aid=1158060544&tkn=*gw3Aym63uOOyl7-aBylAfUYE6xU","stamp":1635577644,"family":"Farber","sid":"12345"},{"given":"Alexander","social":1,"auth":"xyzok","photo":"https://lh3.googleusercontent.com/a-/AOh14GgqDXvSLH3hgFH_6Y9spW6bBBSjVGHQg5X6k3cue2k=s96-c","stamp":1635533473,"family":"Farber","sid":"67890"}]
}
"""

let decoder = JSONDecoder()

if let loginData = jsonLogin?.data(using: .utf8),
   let loginModel = try? decoder.decode(LoginModel.self, from: loginData),
    loginModel.gid == 0,
    loginModel.action == "login"
{
    print("Parsed users: ", loginModel.users)
} else {
    print("Can not parse")
}
