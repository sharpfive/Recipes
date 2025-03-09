//
//  ImageCache.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/5/25.
//

import Foundation
import CryptoKit
import SwiftUI
import CommonCrypto

@MainActor
struct ImageCacheFactory {
    func make() async -> ImageCaching {
        let temporaryDirectoryURL =
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first ??
            URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let fileCache = await FileCache(temporaryDirectoryURL: temporaryDirectoryURL,
                                                  fileManager: .default)
        let imageDownloader = ImageDataDownloader(urlSession: .shared)
        return ImageCache(fileCache: fileCache, imageDownloader: imageDownloader)
    }
}

@MainActor
protocol ImageCaching {
    func image(forURL url: URL) async throws -> UIImage?
    func setImage(_ image: UIImage, for url: URL)
}

@MainActor
class ImageCache: NSObject, ImageCaching, @preconcurrency NSCacheDelegate {
    private(set) lazy var inMemoryCache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.delegate = self
        return cache
    }()

    private let fileCache: FileDataCaching
    private let imageDownloader: ImageDataProviding
    private var taskDictionary = [URL: Task<UIImage, Error>]()

    init(fileCache: FileDataCaching, imageDownloader: ImageDataProviding) {
        self.fileCache = fileCache
        self.imageDownloader = imageDownloader
    }

    func image(forURL url: URL) async -> UIImage? {
        if let existingTask = taskDictionary[url] {
            do {
                return try await existingTask.value
            } catch {
                return nil
            }
        }

        if let cachedImage = inMemoryCache.object(forKey: url as NSURL) {
            globalLogger.debug("Fetch from memory for: \(url)")
            return cachedImage
        }

        let task: Task<UIImage, Error> = taskDictionary[url] ?? task(for: url)
        taskDictionary[url] = task

        do {
            return try await task.value
        } catch {
            return nil
        }
    }

    func task(for url: URL) -> Task<UIImage, Error> {
        Task {
            defer {
                taskDictionary[url] = nil
            }

            do {
                if let data = try? await fileCache.data(forURL: url),
                   let image = UIImage(data: data) {
                    inMemoryCache.setObject(image, forKey: url as NSURL)
                    return image
                }

                globalLogger.debug("Fetch from API: \(url)")
                let data = try await imageDownloader.image(from: url)

                if let image = UIImage(data: data) {
                    inMemoryCache.setObject(image, forKey: url as NSURL)

                    // Question: is it better to return something to the UI as fast as possible, or wait until we've reached a consistent state?
                    // We can avoid concurrency issues by waiting for a consistant state. Performance for this is pretty good. Writing a small file to disk is expected to be pretty quick.
                    // It fills the image as fast as I can scroll on an iPhone 12
                    do {
                        try await fileCache.setData(data, for: url)
                    } catch {
                        globalLogger.error("Error persisting data for \(url): \(error)") // not tested, could create a new stub class that throws an exception
                    }
                    return image
                } else {
                    throw NetworkError.unableToDecode
                }
            } catch {
                globalLogger.error("Error downloading image for \(url): \(error)")
                throw error
            }
        }
    }

    func setImage(_ image: UIImage, for url: URL) {
        inMemoryCache.setObject(image, forKey: url as NSURL)
    }

    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        globalLogger.debug("Cache evicting object")
    }
}
