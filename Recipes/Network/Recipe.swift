//
//  Recipe.swift
//  Recipe
//
//  Created by Jaim Zuber on 3/4/25.
//

import Foundation

struct RecipeDTO: Codable {
    let cuisine: String
    let name: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let uuid: String
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case uuid
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
