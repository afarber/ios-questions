//
//  TopRow.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//

import SwiftUI

struct TopRow: View {
    let topEntity:TopEntity
    
    var body: some View {
        HStack {
            DownloadImage(url: topEntity.photo ?? "TODO")
                .frame(width: 60, height: 60)
            Spacer()
            Text(topEntity.given ?? "Unknown Person")
                .frame(minWidth: 60, maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack {
                Text("elo-rating \(topEntity.elo)")
                Text("avg-time \(topEntity.avg_time ?? "00:00")")
                Text("avg-score \(topEntity.avg_score)")
            }.fixedSize(horizontal: true, vertical: false)
        }.font(.footnote)
    }
}

struct TopRow_Previews: PreviewProvider {
    static var topEntity : TopEntity {
        let topEntity = TopEntity(context: PersistenceController.preview.container.viewContext)
        topEntity.uid = 19265
        topEntity.elo = 2659
        topEntity.given = "Alex"
        topEntity.motto = "TODO"
        topEntity.photo = "https://wordsbyfarber.com/images/female_happy.png"
        topEntity.avg_score = 18.8
        topEntity.avg_time = "03:06"
        return topEntity
    }

    static var previews: some View {
        ForEach(["en", "de", "ru"], id: \.self) { localeId in
            TopRow(topEntity: topEntity)
                .environment(\.locale, .init(identifier: localeId))
                .padding()
                .previewLayout(.sizeThatFits)
                .previewDisplayName("locale: \(localeId)")

        }
    }
}

