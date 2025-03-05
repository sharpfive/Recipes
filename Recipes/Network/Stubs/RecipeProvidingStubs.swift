//
//  RecipeProvidingStubs.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/5/25.
//

// Stubs would normally not be included in the main project. But I'm finding them useful for creating SwiftUI Previews.
// This gives devs instant access to various error cases.
// A potential improvement could be to add them to a separate Target that could be stripped of extra types that aren't meant for production

import Foundation

enum TestError: Error {
    case bundleError
    case setupError
}

struct EmptyNetworkProvidingStub: RecipeProviding {
    func getRecipes() async throws -> RecipesResponse {
        RecipesResponse(recipes: [])
    }
}

struct ErrorNetworkProvidingStub: RecipeProviding {
    func getRecipes() async throws -> RecipesResponse {
        throw NetworkError.unexpectedStatusCode(401)
    }
}

struct AllRecipesNetworkClientStub: RecipeProviding {
    func getRecipes() async throws -> RecipesResponse {
        guard let recipeURL = Bundle.main.url(forResource: "AllRecipesResponse", withExtension: "json") else {
            return .empty
        }

        do {
            let data = try Data(contentsOf: recipeURL)

            let recipesResponse = try JSONDecoder().decode(RecipesResponse.self, from: data)
            return recipesResponse

        } catch {
            return .empty
        }
    }
}

struct AllRecipesDataProvider: DataProviding {
    func getData() async throws -> Data {
        guard let recipeURL = Bundle.main.url(forResource: "AllRecipesResponse", withExtension: "json") else {
            throw TestError.bundleError
        }

        return try Data(contentsOf: recipeURL)
    }
}

struct MalformedRecipesDataProvider: DataProviding {
    func getData() async throws -> Data {
        guard let recipeURL = Bundle.main.url(forResource: "MalformedDataRecipesResponse", withExtension: "json") else {
            throw TestError.bundleError
        }

        return try Data(contentsOf: recipeURL)
    }
}

struct EmptyResponseDataProvider: DataProviding {
    func getData() async throws -> Data {
        guard let recipeURL = Bundle.main.url(forResource: "EmptyDataRecipesResponse", withExtension: "json") else {
            throw TestError.bundleError
        }

        return try Data(contentsOf: recipeURL)
    }
}
