//
//  ImageCacheTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/8/25.
//

import CryptoKit
import Foundation
import Testing
import SwiftUI

@testable import Recipes

@MainActor
struct ImageCacheTests {

    let url = URL(string: "https://example.com/image.png")!
    let redImage = ImageTestData.makeImage(size: CGSize(width: 25, height: 25), color: .red)!
    let smallerRedImage = ImageTestData.makeImage(size: CGSize(width: 25, height: 24), color: .red)!

    func makeSUT() async -> ImageCache {
        let sut = await ImageCache(fileCache: FileCache(temporaryDirectoryURL: URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true),
                                                        fileManager: .default),
                                   imageDownloader: ImageDataDownloadingStub())
        return sut
    }

    @Test func testEmptyCache() async throws {
        await #expect(makeSUT().image(forURL: url) == nil)
    }

    @Test func testBasicCache() async throws {
        let sut = await makeSUT()
        sut.setImage(redImage, for: url)

        let fetchedImage = await sut.image(forURL: url)

        guard let fetchedImage else {
            Issue.record("fetchedImage is nil")
            return
        }
        #expect(fetchedImage == redImage)
        #expect(ImageComparison.hashCompareEqual(image1: fetchedImage, image2: redImage))
    }

    @Test func testFailedComparisonCache() async throws {
        let sut = await makeSUT()
        sut.setImage(redImage, for: url)

        let fetchedImage = await sut.image(forURL: url)

        guard let fetchedImage else {
            Issue.record("fetchedImage is nil")
            return
        }
        #expect(fetchedImage != nil)
        #expect(!ImageComparison.hashCompareEqual(image1: fetchedImage, image2: smallerRedImage))
    }
}
