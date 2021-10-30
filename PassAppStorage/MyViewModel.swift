//
//  MyViewModel.swift
//  PassAppStorage
//
//  Created by Alexander Farber on 24.10.21.
//

import Foundation

class MyViewModel: ObservableObject {
    @Published var language: String = "en"

    init(language: String) {
        fetchMyUser(language: language)
    }
    
    func fetchMyUser(language:String) {
        print("fetchMyUser language=\(language)")
    }
}
