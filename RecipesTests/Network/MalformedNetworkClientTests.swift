//
//  MalformedNetworkClientTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/5/25.
//

import Testing
@testable import Recipes

struct MalformedNetworkClientTests {
    var sut = RecipeNetworkClient(dataProvider: MalformedRecipesDataProvider())

    @Test func testMalformedRecipesThrowsException() async throws {
        await #expect(throws: NetworkError.unableToDecode) {
            try await sut.getRecipes()
        }
    }
}
