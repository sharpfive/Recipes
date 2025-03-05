//
//  RecipesResponse.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/4/25.
//

import Foundation

struct RecipesResponse: Codable {
    let recipes: [RecipeDTO]

    static let empty: RecipesResponse = .init(recipes: [])
}
