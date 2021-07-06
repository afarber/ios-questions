//
//  ContentView.swift
//  TopsBatchInsert
//
//  Created by Alexander Farber on 06.07.21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let labels = [
        "en" : "🇺🇸 EN",
        "de" : "🇩🇪 DE",
        "ru" : "🇷🇺 RU"
    ]
    
    @AppStorage("language") var language:String = "en"

    @StateObject var vm: TopViewModel = TopViewModel()
        
    var body: some View {
        VStack() {

            // ! means "this might trap"
            Picker(selection: $language, label: Text(labels[language]!)) {
                ForEach(labels.sorted(by: <), id: \.key) { key, value in
                    Text(value).tag(key)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            List {
                ForEach(vm.topEntities) { top in
                    TopRow(topEntity: top)
                }
            }
        }.environment(\.locale, .init(identifier: language))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
