//
//  MalformedRecipesViewModelTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/5/25.
//

import Testing
@testable import Recipes

@MainActor
struct MalformedRecipesViewModelTests {
    var sut: RecipesViewModel = {
        let network = RecipeNetworkClient(dataProvider: MalformedRecipesDataProvider())
        return RecipesViewModel(network: network)
    }()

    @Test func testNumberOfRecipesIsEmpty() async throws {
        await sut.getRecipes()
        #expect(sut.recipes.isEmpty)
    }

    @Test func testHasErrorIsFalse() async throws {
        await sut.getRecipes()
        #expect(sut.hasError == true)
    }

    @Test func testIsEmpty() async throws {
        await sut.getRecipes()
        #expect(sut.isEmpty == true)
    }
}
