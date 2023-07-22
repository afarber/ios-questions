//
//  DownloadImage.swift
//  TopsMultiple
//
//  Created by Alexander Farber on 14.07.21.
//

import SwiftUI

struct DownloadImage: View {
    @StateObject var loader: DownloadImageViewModel
    
    init(url: String) {
        _loader = StateObject(wrappedValue: DownloadImageViewModel(url: url))
    }
    
    var body: some View {
        ZStack {
            if loader.isLoading {
                ProgressView()
            } else if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else {
                // TODO show placeholder image
            }
        }
    }
}

struct TopImageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadImage(url: "https://wordsbyfarber.com/images/female_happy.png")
            .frame(width: 60, height: 60)
            .previewLayout(.sizeThatFits)
    }
}
