//
//  ProjectTests.swift
//  ProjectTests
//
//  Created by geotech on 24/06/2021.
//

import XCTest
@testable import Project
var dataAPISUI: DataAPI!
var personSUI: PersonHolder!
class ProjectTests: XCTestCase {
    var ViewControllerSUI: UIViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func testDefine(){
        dataAPISUI = DataAPI(value: [:])
        XCTAssertNotNil(dataAPISUI)
        //Person value
        personSUI = PersonHolder(value: ["email": "rachel.howell@reqres.in", "id": "12", "avatar": "https://reqres.in/img/faces/12-image.jpg", "last_name": "Howell", "first_name": "Rachel"])
        //Data Value
        dataAPISUI = DataAPI(page: 1, perPage: 6, total: 6, totalPages: 1, person: [personSUI], supTxt: "Hi", supURL: "Hi")
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
