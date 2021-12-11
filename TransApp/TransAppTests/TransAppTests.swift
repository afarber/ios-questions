//
//  TransAppTests.swift
//  TransAppTests
//
//  Created by Alexander Farber on 05.12.21.
//

import XCTest
@testable import TransApp

class TransAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameModel() throws {
        let decoder = JSONDecoder()

        let str:String =
"""
{
    "gid":266,
    "letters":[
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,"H", null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,"U", null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,"E", null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
    ],
    "values":[
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null, 4,  null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null, 1,  null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null, 1,  null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null],
        [null,null,null,null,null,null,null,null,null,null,null,null,null,null,null]
    ],
    "tiles":[
        {"col": 8, "row": 7, "value": 1, "letter": "E"},
        {"col": 7, "row": 7, "value": 1, "letter": "U"},
        {"col": 6, "row": 7, "value": 4, "letter": "H"}
    ]
}
"""
        guard let data = str.data(using: .utf8),
              let gameModel = try? decoder.decode(GameModel.self, from: data),
              gameModel.gid == 266,
              gameModel.tiles?[0].col == 8
        else
        {
            XCTFail()
            return
        }
        
        // add square brackets around the str, to test parsing of a games array
        guard let data = "[\(str)]".data(using: .utf8),
              let gamesModel = try? decoder.decode([GameModel].self, from: data),
              gamesModel[0].gid == 266,
              gamesModel[0].tiles?[1].col == 7
        else
        {
            XCTFail()
            return
        }
    }
}
