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

