//
//  TopRow.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import SwiftUI

struct TopRow: View {
    let model:Top
    
    var body: some View {
        HStack {
            Text(model.given)
                .frame(minWidth: 60, maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Text("Elo rating: \(model.elo)")
                Text("Average time: \(model.avg_time ?? "")")
                Text("Average score: \(String(model.avg_score ?? 0.0))")
            }.fixedSize(horizontal: true, vertical: false)
            Spacer()
            DownloadingImage(url: model.photo ?? "TODO")
                .frame(width: 60, height: 60)
        }.font(.footnote)
    }
}

struct TopRow_Previews: PreviewProvider {
    static var previews: some View {
        TopRow(model: Top(
            uid: 19265,
            elo: 2659,
            given: "Alex",
            photo: "https://slova.de/words/images/female_happy.png",
            motto: nil,
            avg_score: 18.8,
            avg_time: "03:06"
        ))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
