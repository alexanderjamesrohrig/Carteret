//
//  CloudKitActor.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/27/25.
//

import Foundation
import CloudKit

actor CloudKitActor {
    var iCloudDriveAvailable: Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            return true
        } else {
            return false
        }
    }
}
