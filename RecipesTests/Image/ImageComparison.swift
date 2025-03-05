//
//  ImageComparison.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/8/25.
//

import CryptoKit
import Foundation
import SwiftUI

struct ImageComparison {
    static func hashImage(image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }

        // Create an MD5 hash using CryptoKit's Insecure namespace
        let digest = Insecure.MD5.hash(data: imageData)

        // Convert the MD5 digest to a hexadecimal string
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func hashCompareEqual(image1: UIImage, image2: UIImage) -> Bool {
        guard let hash1 = hashImage(image: image1), let hash2 = hashImage(image: image2) else {
            return false
        }
        return hash1 == hash2
    }
}
