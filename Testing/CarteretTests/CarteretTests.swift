//
//  CarteretTests.swift
//  CarteretTests
//
//  Created by Alexander Rohrig on 1/30/24.
//

import XCTest
@testable import Carteret

final class CarteretTests: XCTestCase {
    let transactions: [Transaction] = [
        Transaction(
            destination: .safeToSpend,
            category: .other,
            item: nil,
            amount: 50.00,
            type: .expense,
            transactionDescription: "Test 1",
            date: Date.now
        ),
        Transaction(
            destination: .safeToSpend,
            category: .other,
            item: nil,
            amount: 50.00,
            type: .expense,
            transactionDescription: "Test 2",
            date: Date.now
        ),
        Transaction(
            destination: .safeToSpend,
            category: .other,
            item: nil,
            amount: 100.00,
            type: .income,
            transactionDescription: "Test 3",
            date: Date.now
        )
    ]
    
    // MARK: - BudgetManager
    func testBudgetManagerCalculateBalance() throws {
        let budgetManager = BudgetManager()
        budgetManager.calculateBalance(from: transactions)
        let balance = budgetManager.runningBalance
        let expected: Currency = 0.00
        XCTAssertEqual(balance, expected)
    }
    
    func testBudgetManagerDisplaySpendingLimit() throws {
        let budgetManager = BudgetManager()
        budgetManager.spendingLimit = 1234.56
        // TODO: Localize
        let expected = "$1,234.56"
        XCTAssertEqual(budgetManager.displaySpendingLimit, expected)
    }
    
    // MARK: - Int+
    func testIntDisplay() throws {
        let number: Int = 510
        let expected = "$5.10"
        XCTAssertEqual(number.display, expected)
    }
    
    func testIntToDecimal() throws {
        let number: Int = 510
        let expected: Double = 5.10
        XCTAssertEqual(number.toDecimal, expected)
    }
    
    // MARK: - Double+
    func testDoubleRemoveDecimal() throws {
        throw XCTSkip("Function no longer available")
    }
    
    // MARK: - String+
    func testStringToInt() throws {
        throw XCTSkip("Function no longer available")
    }
    
    // MARK: - Calendar
    // TODO: currentWeek
    // TODO: week()
    
    // MARK: - Date
    func testDateMedium() throws {
        let today = Date.now
        XCTAssertFalse(today.medium.isEmpty)
    }
    
    // MARK: - Locale
    
    // MARK: - Decimal
    func testDecimalZero() throws {
        let expected: Decimal = 0.00
        XCTAssertEqual(Decimal.zero, expected)
    }
    
    func testDecimalFromString() throws {
        let number = Decimal.from(string: "5.10")
        let expected: Decimal = 5.10
        XCTAssertEqual(number, expected)
    }
    
    func testDecimalDisplay() throws {
        let number: Decimal = 5.10
        let expected = "$5.10"
        XCTAssertEqual(number.display, expected)
    }
    
    func testDecimalToDouble() throws {
        let number: Decimal = 5.10
        let expected: Double = 5.10
        XCTAssertEqual(number.toDouble, expected)
    }
    
    // MARK: - View
}
