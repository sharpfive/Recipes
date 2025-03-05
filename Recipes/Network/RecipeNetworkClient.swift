//
//  RecipeNetworkClient.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/4/25.
//

import Foundation

protocol RecipeProviding: Sendable {
    func getRecipes() async throws -> RecipesResponse
}

enum RecipesError: Error {
    case configurationError
}

struct NetworkClientFactory {
    let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    func make() throws -> RecipeProviding {
        guard let url = URL(string: urlString) else {
            throw RecipesError.configurationError
        }
        let dataProvider = NetworkDataProviding(url: url,
                                                urlSession: .shared)
        let client = RecipeNetworkClient(dataProvider: dataProvider)
        return client
    }
}

struct ErrorNetworkClient: RecipeProviding {
    func getRecipes() async throws -> RecipesResponse {
        throw NetworkError.configurationError
    }
}

struct RecipeNetworkClient: RecipeProviding {
    let dataProvider: DataProviding

    func getRecipes() async throws -> RecipesResponse {
        let data = try await dataProvider.getData()

        do {
            let recipeResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
            return recipeResponse
        } catch {
            throw NetworkError.unableToDecode
        }
    }
}
