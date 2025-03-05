//
//  RecipesView.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/4/25.
//

import SwiftUI

struct RecipesView: View {
    static let imageWidthHeight: CGFloat = 60
    @State var viewModel: RecipesViewModel = RecipesViewModelFactory().make()

    var body: some View {
        if viewModel.isLoading {
            VStack {
                Spacer()
                Text("Loading Recipes...")
                    .font(.headline)
                ProgressView()
                Spacer()
            }.task {
                await viewModel.setup()
            }
        } else {
            VStack {
                Text("Recipes")
                    .font(.title)
                GeometryReader { geometry in
                    ScrollView {
                        if viewModel.hasError {
                            FullScreenStatusView(text: "We encountered an error")
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                        else if viewModel.isEmpty {
                            FullScreenStatusView(text: "No recipes found")
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        } else {
                            LazyVStack(alignment: .leading) {
                                ForEach(viewModel.recipes, id: \.uuid) { recipe in
                                    HStack {
                                        if let recipeURL = recipe.imageURL {
                                            CachedImageView(url: recipeURL, imageCache: viewModel.imageCache)
                                                .frame(width: Self.imageWidthHeight, height: Self.imageWidthHeight)
                                        }
                                        else {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.gray.opacity(0.3))
                                                .frame(width: Self.imageWidthHeight, height: Self.imageWidthHeight)
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(.gray.opacity(0.3))
                                                .frame(width: Self.imageWidthHeight, height: Self.imageWidthHeight)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(recipe.name)
                                                .font(.headline)
                                            Text(recipe.cuisine)
                                                .font(.subheadline)

                                        }
                                    }
                                }
                            }
                        }
                    }.refreshable {
                        Task {
                            await viewModel.getRecipes()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    RecipesView(viewModel:
        RecipesViewModel(
            network: RecipeNetworkClient(
            dataProvider: AllRecipesDataProvider())))
}

#Preview {
    RecipesView(viewModel: RecipesViewModel(network: EmptyNetworkProvidingStub()))
}

#Preview {
    RecipesView(viewModel: RecipesViewModel(network: ErrorNetworkProvidingStub()))
}

#Preview {
    RecipesView( viewModel: RecipesViewModel(
            network: RecipeNetworkClient(
                dataProvider: MalformedRecipesDataProvider())))
}


