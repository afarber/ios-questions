//
//  GameEntity+Extensions.swift
//  TransApp
//
//  Created by Alexander Farber on 11.12.21.
//

import Foundation

extension GameEntity {
    var lettersArray: [[String?]] {
        get {
            guard let data = letters?.data(using: .utf8) else { return [[String?]]() }
            return try! JSONDecoder().decode([[String?]].self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { letters = nil; return }
            letters = String(data: data, encoding: .utf8)
        }
    }
    var valuesArray: [[Int32?]] {
        get {
            guard let data = values?.data(using: .utf8) else { return [[Int32?]]() }
            return try! JSONDecoder().decode([[Int32?]].self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { values = nil; return }
            values = String(data: data, encoding: .utf8)
        }
    }
    var tilesArray: [TileModel]? {
        get {
            guard let data = tiles?.data(using: .utf8) else { return nil }
            return try? JSONDecoder().decode([TileModel].self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { tiles = nil; return }
            tiles = String(data: data, encoding: .utf8)
        }
    }
}
