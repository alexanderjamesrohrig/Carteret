//
//  Week.swift
//  Carteret
//
//  Created by Alexander Rohrig on 1/17/25.
//

import Foundation

struct Week: Codable {
    let number: Int
    let start: Date
    let end: Date
    
    private var endDouble: Double {
        end.timeIntervalSinceReferenceDate
    }
    
    private var startDouble: Double {
        start.timeIntervalSinceReferenceDate
    }
    
    var weekProgress: Double {
        Date.now.timeIntervalSinceReferenceDate - startDouble
    }
    
    var weekProgressTotal: Double {
        endDouble - startDouble
    }
}
