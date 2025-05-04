//
//  DebugSettings.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import Foundation

@MainActor class DebugSettings: ObservableObject {
    @Published var showSavingsRow = false
}

#if canImport(UIKit)
import UIKit

extension DebugSettings {
    var osVersion: String {
        UIDevice.current.systemVersion
    }
}
#endif
