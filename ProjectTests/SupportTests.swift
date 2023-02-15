//
//  personTests.swift
//  ProjectTests
//
//  Created by geotech on 28/06/2021.
//

import XCTest
@testable import Project
class personTests: XCTestCase {
    var supportSUI : SupportClass!
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }
    
    func testDefineSupport(){
        supportSUI = SupportClass(value: ["url":"linking", "text": "Click here"])
        XCTAssertNotNil(supportSUI)
        supportSUI = SupportClass(value: [:])
        XCTAssertNotNil(supportSUI)
    }
  
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        supportSUI = nil
        try super.tearDownWithError()
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
