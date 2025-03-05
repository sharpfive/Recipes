//
//  NetworkError.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/8/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case unableToDecode
    case invalidResponse
    case unexpectedStatusCode(Int)
    case configurationError
}
