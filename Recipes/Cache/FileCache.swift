//
//  FileCache.swift
//  Recipes
//
//  Created by Jaim Zuber on 3/8/25.
//

import CryptoKit
import Foundation

@FileSystemActor
protocol FileDataCaching: Sendable {
    func data(forURL url: URL) async throws -> Data?
    func setData(_ data: Data, for url: URL) throws
}

@FileSystemActor
struct FileCache: FileDataCaching {
    let temporaryDirectoryURL: URL
    let fileManager: FileManager

    func data(forURL url: URL) async throws -> Data? {
        let path = fileURL(forURL: url)
        globalLogger.debug("Fetch from disk for \(url) - location: \(path)")
        if fileManager.fileExists(atPath: path.path),
            let data = try? Data(contentsOf: path) {
            return data
        } else {
            return nil
        }
    }

    func setData(_ data: Data, for url: URL) throws {
        let path = fileURL(forURL: url)
        globalLogger.debug("Persist to disk: \(url) - location: \(path)")
        if fileManager.fileExists(atPath: path.path) {
            try fileManager.removeItem(at: path) // Not tested, we could stub out the FileManager to test this case
            fileManager.createFile(atPath: path.path, contents: data)
        }

        fileManager.createFile(atPath: path.path, contents: data)
    }

    func fileURL(forURL url: URL) -> URL {
        temporaryDirectoryURL.appendingPathComponent(createHash(for: url))
    }

    private func createHash(for url: URL) -> String {
        let data = Data(url.absoluteString.utf8)
        let digest = Insecure.MD5.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
