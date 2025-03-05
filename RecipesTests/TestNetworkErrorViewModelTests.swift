//
//  TestNetworkErrorViewModelTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/5/25.
//

import Testing
@testable import Recipes

@MainActor
struct TestNetworkErrorViewModelTests {
    var sut: RecipesViewModel = {
        RecipesViewModel(network: ErrorNetworkProvidingStub())
    }()

    @Test func testNumberOfRecipesIsEmpty() async throws {
        await sut.getRecipes()
        #expect(sut.recipes.isEmpty)
    }

    @Test func testHasError() async throws {
        await sut.getRecipes()
        #expect(sut.hasError == true)
    }

    @Test func testIsEmpty() async throws {
        await sut.getRecipes()
        #expect(sut.isEmpty == true)
    }
}
