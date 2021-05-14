//
//  TopImageView.swift
//  FetchJsonEscapable
//
//  Created by Alexander Farber on 13.05.21.
//

import SwiftUI

struct DownloadingImage: View {
    @StateObject var loader: DownloadingImageViewModel
    
    init(url: String, key: String) {
        _loader = StateObject(wrappedValue: DownloadingImageViewModel(url: url, key: key))
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
        DownloadingImage(url: "https://via.placeholder.com/600/92c952", key: "123")
            .frame(width: 75, height: 75)
            .previewLayout(.sizeThatFits)
    }
}
