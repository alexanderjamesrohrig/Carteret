//
//  UniversalImage.swift
//  Carteret
//
//  Created by Alexander Rohrig on 5/1/25.
//

import Foundation
import SwiftUI

// TODO: Move to RSCCore

public struct UniversalImage {
    let data: Data
}

// MARK: iOS
#if canImport(UIKit)
import UIKit

extension UniversalImage {
    public typealias Image = UIImage
    public typealias Configuration = Image.Configuration
    public typealias SymbolConfiguration = Image.SymbolConfiguration
    
    public func uiImage(systemName: String) -> UIImage? {
        return UIImage(systemName: systemName)
    }
    
    public func uiImage(systemName: String, with configuration: UIImage.Configuration?) -> UIImage? {
        return UIImage(systemName: systemName, withConfiguration: configuration)
    }
}
#endif

// MARK: macOS
#if canImport(AppKit)
extension UniversalImage {
    public typealias Image = NSImage
    public typealias SymbolConfiguration = NSImage.SymbolConfiguration
}
#endif
