//
//  ImageTestData.swift
//  RecipesTests
//
//  Created by Jaim Zuber on 3/8/25.
//

import Foundation
import SwiftUI

struct ImageTestData {
    static let redImage = Self.makeImage(size: CGSize(width: 25, height: 25), color: .red)!

    static func makeImage(size: CGSize, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        color.setFill()

        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return image
    }
}

