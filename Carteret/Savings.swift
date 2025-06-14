//
//  Savings.swift
//  Carteret
//
//  Created by Alexander Rohrig on 6/13/25.
//

import Foundation
import OSLog

struct Savings: Codable {
    enum SavingsType: Codable {
        case percentage
        case currencyAmount
    }
    
    static let empty = Savings(amount: 0.00, type: .currencyAmount)
    
    static func from(data: Data) -> Savings {
        do {
            return try JSONDecoder().decode(Savings.self, from: data)
        } catch {
            print("\(#function) Decoding error")
        }
        return Savings.empty
    }
    
    let amount: Currency
    let type: SavingsType
    
    var toData: Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            logger.error("Encoding error")
        }
        return Data()
    }
}

extension Savings {
    fileprivate var logger: Logger {
        Logger(subsystem: Constant.subsystem, category: "Savings")
    }
}
