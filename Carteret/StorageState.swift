//
//  StorageState.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/24/25.
//

/// State of stored SwiftData model
/// - `0` :- saved, active
/// - `1` :- archived
enum StorageState: Int, RawRepresentable, Codable {
    case saved = 0
    case archived = 1
}
