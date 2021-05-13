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
        
        VStack {
            Text(model.given)
            
            HStack {
                Text(String(model.elo))
                Spacer()
                Text(model.avg_time ?? "")
                Spacer()
                Text(String(model.avg_score ?? 0))
            }
        }
    }
}

struct TopRow_Previews: PreviewProvider {
    static var previews: some View {
        TopRow(model: Top(
                uid: 19265,
                elo: 2659,
                given: "Alex",
                photo: "https://avt-20.foto.mail.ru/mail/farber72/_avatar180",
                motto: nil,
                avg_score: 18.8,
                avg_time: "03:06"
            ))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
