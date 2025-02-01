//
//  PreviewActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 2/1/25.
//

import Foundation
import SwiftData
import OSLog

@MainActor
struct PreviewHelper {
    private let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    private let logger = Logger(subsystem: Constant.carteretSubsystem,
                                category: "PreviewActor")
    
    var container: ModelContainer {
        do {
            let container = try ModelContainer(for: Item.self,
                                               configurations: configuration)
            return container
        } catch {
            logger.error("Unable to create SwiftData container")
            fatalError("Unable to create SwiftData container")
        }
    }
}
