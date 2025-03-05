//
//  EmptyResponseNetworkClientTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/5/25.
//

import Testing
@testable import Recipes

struct EmptyResponseNetworkClientTests {
    var sut = RecipeNetworkClient(dataProvider: EmptyResponseDataProvider())

    @Test func testRecipesCountIsZero() async throws {
        #expect(try await sut.getRecipes().recipes.count == 0)
    }
}
