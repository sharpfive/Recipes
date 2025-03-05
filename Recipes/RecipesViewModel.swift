//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/4/25.
//

import Foundation

struct RecipeViewModel {
    let name: String
    let cuisine: String
    let imageURL: URL?
    let uuid: String
}

@MainActor
struct RecipesViewModelFactory {
    func make() -> RecipesViewModel {
        let networkClient: RecipeProviding
        do {
            networkClient = try NetworkClientFactory().make()
        } catch {
            networkClient = ErrorNetworkClient()
        }

        return RecipesViewModel(network: networkClient)
    }
}

@MainActor
@Observable
class RecipesViewModel{
    private(set) var recipes = [RecipeViewModel]()

    var isEmpty: Bool {
        recipes.isEmpty
    }

    private(set) var hasError = false
    private(set) var isLoading = true

    private(set) var imageCache: ImageCaching!
    private let network: RecipeProviding
    private let imageCacheFactory: ImageCacheFactory

    init(network: RecipeProviding, imageCacheFactory: ImageCacheFactory = ImageCacheFactory()) {
        self.network = network
        self.imageCacheFactory = imageCacheFactory
    }

    func getRecipes() async {
        do {
            recipes.removeAll()
            hasError = false
            let response = try await network.getRecipes()
            recipes = response.recipes.map {
                makeRecipeFromDTO($0)
            }
        } catch {
            print("error: \(error)")
            hasError = true
            recipes = [RecipeViewModel]()
        }
    }

    func makeRecipeFromDTO(_ recipe: RecipeDTO) -> RecipeViewModel {
        let imageURL: URL?
        if let photoURLString = recipe.photoURLSmall,
           let url = URL(string: photoURLString) {
            imageURL = url
        } else {
            imageURL = nil // not tested, would need to create stub data that has a nil value for photoURLSmall
        }

        return RecipeViewModel(
            name: recipe.name,
            cuisine: recipe.cuisine,
            imageURL: imageURL,
            uuid: recipe.uuid)
    }

    func setup() async {
        imageCache = await imageCacheFactory.make()
        await getRecipes()
        isLoading = false
    }
}
