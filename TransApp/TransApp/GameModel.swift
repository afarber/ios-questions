//
//  GameModel.swift
//  TransApp
//
//  Created by Alexander Farber on 05.12.21.
//

import Foundation
import SwiftUI
import CoreData

struct GameResponse: Codable {
    let game: GameModel
}

struct GameModel: Codable, Identifiable {
    var id: Int32 { gid }
    let gid: Int32
    let letters: [[String?]]
    let values: [[Int32?]]
    let tiles: [TileModel]? // the prevous move as an array

    // create a new Core Data entity and copy the properties
    func toEntity(viewContext: NSManagedObjectContext) -> GameEntity {
        let encoder = JSONEncoder()
        let gameEntity = GameEntity(context: viewContext)
        gameEntity.gid = self.gid
        gameEntity.letters = try? encoder.encode(self.letters)
        gameEntity.values = try? encoder.encode(self.values)
        gameEntity.tiles = try? encoder.encode(self.tiles)
        return gameEntity
    }
}

struct TileModel: Codable {
    let col: Int
    let row: Int
    let value: Int
    let letter: String
}
