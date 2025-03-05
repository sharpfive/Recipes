//
//  ImageDataDownloader.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/8/25.
//

import Foundation

protocol ImageDataProviding: Sendable {
    func image(from url: URL) async throws -> Data
}

struct ImageDataDownloader: ImageDataProviding {
    let urlSession: URLSession

    func image(from url: URL) async throws -> Data {
        let (data, _) = try await urlSession.data(from: url)
        return data
    }
}
