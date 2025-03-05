//
//  NetworkDataProviding.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/8/25.
//

import Foundation

protocol DataProviding: Sendable {
    func getData() async throws -> Data
}

struct NetworkDataProviding: DataProviding {
    let url: URL
    let urlSession: URLSession

    func getData() async throws -> Data {
        let (data, response) = try await urlSession.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.invalidResponse}

        if !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
        }

        return data
    }
}
