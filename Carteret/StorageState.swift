//
//  StorageState.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/24/25.
//

enum StorageState: Int, RawRepresentable, Codable {
    case saved = 0
    case archived = 1
}
