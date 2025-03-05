//
//  ImageCacheFileStubTests.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/8/25.
//

import SwiftUI
import Testing

@testable import Recipes

@FileSystemActor
class FileCacheStub: FileDataCaching {
    var dataInvoked = [URL]()
    var setDataInvoked = [(Data, URL)]()
    var data = [URL: Data]()

    func data(forURL url: URL) async throws -> Data? {
        dataInvoked.append(url)
        return data[url]
    }

    func setData(_ data: Data, for url: URL) throws {
        setDataInvoked.append((data, url))
    }

    func stubData(url: URL, data stubData: Data) {
        data[url] = stubData
    }
}

@MainActor
class ImageDataDownloadingStub: ImageDataProviding {
    var imageInvoked = [URL]()
    var imageData = [URL: Data]()

    func image(from url: URL) async throws -> Data {
        imageInvoked.append(url)

        if let imageData = imageData[url] {
            return imageData
        } else {
            throw NetworkError.unexpectedStatusCode(404)
        }
    }
}

struct ImageDataDownloadingErrorStub: ImageDataProviding {
    func image(from url: URL) async throws -> Data {
        throw NetworkError.unableToDecode
    }
}

@MainActor
struct ImageCacheFileStubTests {
    let url = URL(string: "https://example.com/image.png")!

    lazy var fileCacheStub: FileCacheStub = {
        .init()
    }()

    lazy var imageDataDownloadingStub = {
        ImageDataDownloadingStub()
    }()

    lazy var sut: ImageCache = {
        ImageCache(fileCache: fileCacheStub,
                   imageDownloader: imageDataDownloadingStub)
    }()

    @Test mutating func testSetup() async throws {
        let _ = sut

        await #expect(fileCacheStub.dataInvoked.isEmpty)
        await #expect(fileCacheStub.setDataInvoked.isEmpty)
    }

    @Test mutating func test404RequestWillReturnNil() async throws {
        let image = await sut.image(forURL: url)

        #expect(image == nil)
    }

    @Test mutating func testFirstRequestWillReturnData() async throws {
        await setupFileImage()

        let image = await sut.image(forURL: url)

        #expect(image != nil)
    }

    @Test mutating func testFirstRequestWillRequestFromFile() async throws {
        await _ = sut.image(forURL: url)

        await #expect(fileCacheStub.dataInvoked.first == url)
    }

    mutating func setupFileImage() async {
        let redImageData = ImageTestData.redImage.pngData()!
        await fileCacheStub.stubData(url: url, data: redImageData)
    }
}
