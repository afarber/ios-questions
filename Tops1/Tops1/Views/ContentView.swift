//
//  ContentView.swift
//  Tops1
//
//  Created by Alexander Farber on 03.06.21.
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
            
            HStack {
                Text("app-title")
                Spacer()
                
                // ! means "this might trap"
                Menu(labels[language]!) {
                    ForEach(labels.sorted(by: <), id: \.key) { key, value in
                        Button(value, action: { language = key })
                    }
                }
            }.padding()
            
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
