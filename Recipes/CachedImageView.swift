//
//  CachedImageView.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/4/25.
//

import SwiftUI

struct CachedImageView: View {
    let url: URL
    @State var imageCache: ImageCaching

    @State var image: UIImage? = nil
    @State var showError = false

    var loaded = false
    var body: some View {
        if showError {
            RoundedRectangle(cornerRadius: 4)
                .fill(.red.opacity(0.3))
        }
        else if let uiImage = image {
            Image(uiImage: uiImage).resizable().scaledToFit()
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.3))
                ProgressView()
            }.task {
                do {
                    image = try await imageCache.image(forURL: url)
                } catch {
                    globalLogger.error("imageCache Error: \(error)")
                    showError = true
                }
            }
        }
    }
}
