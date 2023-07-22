//
//  TopImageView.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import SwiftUI

struct DownloadingImage: View {
    @StateObject var loader: DownloadingImageViewModel
    
    init(url: String) {
        _loader = StateObject(wrappedValue: DownloadingImageViewModel(url: url))
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
        DownloadingImage(url: "https://wordsbyfarber.com/images/female_happy.png")
            .frame(width: 75, height: 75)
            .previewLayout(.sizeThatFits)
    }
}
