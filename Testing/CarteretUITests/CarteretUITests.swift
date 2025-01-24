//
//  CarteretUITests.swift
//  CarteretUITests
//
//  Created by Alexander Rohrig on 1/30/24.
//

import XCTest

final class CarteretUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCreateNewItem() throws {
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Create a new item"]/*[[".cells.buttons[\"Create a new item\"]",".buttons[\"Create a new item\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let amountTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Amount ($)"]/*[[".cells.textFields[\"Amount ($)\"]",".textFields[\"Amount ($)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        amountTextField.tap()
        amountTextField.tap()
        app.toolbars["Toolbar"]/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["Every week"]/*[[".cells",".buttons[\"How often?, Every week\"].staticTexts[\"Every week\"]",".staticTexts[\"Every week\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
