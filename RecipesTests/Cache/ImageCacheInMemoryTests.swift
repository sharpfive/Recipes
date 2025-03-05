//
//  ImageCacheInMemoryTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/8/25.
//

import Testing
import SwiftUI
@testable import Recipes

@MainActor
struct ImageCacheInMemoryTests {
    let url = URL(string: "https://example.com/image.png")!
    let smallerRedImage = ImageTestData.makeImage(size: CGSize(width: 25, height: 24), color: .red)!

    lazy var fileCacheStub: FileCacheStub = {
        .init()
    }()

    lazy var sut : ImageCache = {
        ImageCache(fileCache: fileCacheStub,
                   imageDownloader: ImageDataDownloadingStub())
    }()

    @Test mutating func testSetup() async throws {
        let _ = sut

        await #expect(fileCacheStub.dataInvoked.isEmpty)
        await #expect(fileCacheStub.setDataInvoked.isEmpty)
    }

    @Test mutating func testFirstRequestWillReturnNil() async throws {
        let image = await sut.image(forURL: url)

        #expect(image == nil)
    }

    @Test mutating func testFirstRequestWillReturnData() async throws {
        setupInMemoryImage()

        let image = await sut.image(forURL: url)

        #expect(image != nil)
    }

    @Test mutating func testFirstRequestWillNotRequestFromFile() async throws {
        setupInMemoryImage()

        await _ = sut.image(forURL: url)

        await #expect(fileCacheStub.dataInvoked.isEmpty)
    }

    mutating func setupInMemoryImage() {
        sut.inMemoryCache.setObject(ImageTestData.redImage, forKey: url as NSURL)
    }
}
