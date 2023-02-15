//
//  ProjectUITests.swift
//  ProjectUITests
//
//  Created by geotech on 24/06/2021.
//

import XCTest

class ProjectUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    func testBtnPressed(){
        app.buttons["btn1"].tap()
        app.buttons["btn2"].tap()
     
    }
    
    func testPressCell(){
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).tap()
        app.navigationBars["Project.InfomationView"].buttons["Back"].tap()
        tablesQuery.children(matching: .cell).element(boundBy: 1).tap()
    }
    
    func testPressSendEmail(){
        app.tables.children(matching: .cell).element(boundBy: 0).children(matching: .other).element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Send Email"]/*[[".buttons[\"Send Email\"].staticTexts[\"Send Email\"]",".staticTexts[\"Send Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
    }
    
    func testSearchBar(){
        
        let app = XCUIApplication()
        app.tables.children(matching: .cell).element(boundBy: 0).swipeDown()
        app.navigationBars["Project.View"].searchFields["Enter text"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    func testSwipeLeftToDelete(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        let textView = cell.children(matching: .textView).element(boundBy: 0)
        textView.swipeLeft()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                        
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
