//
//  TopModel.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
//

import Foundation

struct TopResponse: Codable {
    let data: [TopModel]
}

struct TopModel: Codable, Identifiable {
    var id: Int { uid }
    let uid: Int
    let elo: Int
    let given: String
    let photo: String?
    let motto: String?
    let avg_score: Double?
    let avg_time: String?
}
