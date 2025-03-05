//
//  RecipesViewModelTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/4/25.
//

import Testing
@testable import Recipes

@MainActor
struct RecipesViewModelTests {
    var sut: RecipesViewModel = {
        let network = RecipeNetworkClient(dataProvider: AllRecipesDataProvider())
        return RecipesViewModel(network: network)
    }()

    @Test func testInitialStateRecipesAreZero() async throws {
        #expect(sut.recipes.count == 0)
    }

    @Test func testInitialStatesIsLoading() async throws {
        #expect(sut.isLoading == true)
    }

    @Test func testNumberOfRecipesIs63() async throws {
        await sut.getRecipes()
        #expect(sut.recipes.count == 63)
    }

    @Test func testHasErrorIsFalse() async throws {
        await sut.getRecipes()
        #expect(sut.hasError == false)
    }

    @Test func testIsNotEmpty() async throws {
        await sut.getRecipes()
        #expect(sut.isEmpty == false)
    }

    @Test func testLastRecipeExists() async throws {
        await sut.getRecipes()
        let lastRecipe = sut.recipes.last
        #expect(lastRecipe != nil)
    }

    @Test func testLastRecipeNameIsCremuBrule() async throws {
        let lastRecipeName = try await getLastRecipe().name
        #expect(lastRecipeName == "White Chocolate Crème Brûlée")
    }

    @Test func testLastRecipeCuisineIsFrench() async throws {
        let lastRecipeCuisine = try await getLastRecipe().cuisine
        #expect(lastRecipeCuisine == "French")
    }

    @Test func testLastRecipeURL() async throws {
        let lastRecipeURLString = try await getLastRecipe().imageURL?.absoluteString
        #expect(lastRecipeURLString == "https://d3jbb8n5wk0qxi.cloudfront.net/photos/f4b7b7d7-9671-410e-bf81-39a007ede535/small.jpg")
    }

    func getLastRecipe() async throws -> RecipeViewModel {
        await sut.getRecipes()
        guard let lastRecipe = sut.recipes.last else { throw TestError.setupError }
        return lastRecipe
    }
}
