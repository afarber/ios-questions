//
//  TopModel.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import Foundation

struct TopResponse: Codable {
    let data: [Top]
}

struct Top: Codable, Identifiable {
    var id: Int { uid }
    let uid: Int
    let elo: Int
    let given: String
    let photo: String?
    let motto: String?
    let avg_score: Double?
    let avg_time: String?
}
