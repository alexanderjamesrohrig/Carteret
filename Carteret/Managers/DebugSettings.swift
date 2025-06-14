//
//  DebugSettings.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/19/25.
//

import Foundation

@MainActor class DebugSettings: ObservableObject {
    enum Feature: String {
        case savingsRow
        case connectToWallet
        case connectToAkoya
        case connectToPlaid
    }
    
    init() {
#if DEBUG
        enabledDebug(features: debugFeatures)
#endif
    }
    
    let debugFeatures: Set<Feature> = [
        .savingsRow,
        .connectToWallet
    ]
    
    @Published var showSavingsRow = true
    @Published var connectToWalletEnabled = false
    @Published var connectToAkoyaEnabled = false
    @Published var connectToPlaidEnabled = false
    
    func enabledDebug(features: Set<Feature>) {
        for feature in features {
            switch feature {
            case .savingsRow:
                showSavingsRow = true
            case .connectToWallet:
                connectToWalletEnabled = true
            case .connectToAkoya:
                connectToAkoyaEnabled = true
            case .connectToPlaid:
                connectToPlaidEnabled = true
            }
        }
    }
}

#if canImport(UIKit)
import UIKit

extension DebugSettings {
    var osVersion: String {
        UIDevice.current.systemVersion
    }
}
#endif

#if canImport(AppKit)
import AppKit

extension DebugSettings {
    var osVersion: String {
        "TODO"
    }
}
#endif
