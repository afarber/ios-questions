//
//  TopRow.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import SwiftUI

struct TopRow: View {
    let top:TopEntity
    
    var body: some View {
        HStack {
            DownloadingImage(url: top.photo ?? "TODO")
                .frame(width: 60, height: 60)
            Spacer()
            Text(top.given ?? "unknown")
                .frame(minWidth: 60, maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Text("Elo rating: \(top.elo)")
                Text("Average time: \(top.avg_time ?? "")")
                Text("Average score: \(String(top.avg_score))")
            }.fixedSize(horizontal: true, vertical: false)
        }.font(.footnote)
    }
}

/*
struct TopRow_Previews: PreviewProvider {
    static var previews: some View {
        let topEntity = TopEntity(context: PersistenceController.preview.container.viewContext)
        topEntity.uid = 19265
        topEntity.elo = 2659
        topEntity.given = "Alex"
        topEntity.motto = "TODO"
        topEntity.photo = "https://slova.de/words/images/female_happy.png"
        topEntity.avg_score = 18.8
        topEntity.avg_time = "03:06"
        
        TopRow(top: topEntity)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
 */
