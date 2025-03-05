//
//  NetworkTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/5/25.
//

import Testing
@testable import Recipes

struct AllRecipeNetworkClientTests {
    var sut = RecipeNetworkClient(dataProvider: AllRecipesDataProvider())

    @Test func allRecipesReturns63Recipes() async throws {
        #expect(try await sut.getRecipes().recipes.count == 63)
    }

    @Test func firstRecipeNameIsApamBalik() async throws {
        #expect(try await sut.getRecipes().recipes.first?.name == "Apam Balik")
    }

    @Test func firstRecipeCuisineIsIsMalaysian() async throws {
        #expect(try await sut.getRecipes().recipes.first?.cuisine == "Malaysian")
    }

    @Test func firstRecipeSmallPhoto() async throws {
        #expect(try await sut.getRecipes().recipes.first?.photoURLSmall == "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
    }
}
