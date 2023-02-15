//
//  personTest.swift
//  ProjectTests
//
//  Created by geotech on 02/07/2021.
//

import XCTest
@testable import Project
class personTest: XCTestCase {
    var personSUI: PersonHolder!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }
    func testDefinePerson(){
        personSUI = PersonHolder(value: ["email": "rachel.howell@reqres.in", "id": 12, "avatar": "https://reqres.in/img/faces/12-image.jpg", "last_name": "Howell", "first_name": "Rachel"])
        XCTAssertNotNil(personSUI.avatar)
        personSUI = PersonHolder(value: [:])
        XCTAssertNotNil(personSUI.avatar)
        personSUI = PersonHolder(id: 12, email: "rachel.howell@reqres.in", firstName: "Rachel", lastName: "Howell", avatar: "https://reqres.in/img/faces/12-image.jpg")
    }
    func testIdIsString(){
        personSUI = PersonHolder(value: ["email": "rachel.howell@reqres.in", "id": "12", "avatar": "https://reqres.in/img/faces/12-image.jpg", "last_name": "Howell", "first_name": "Rachel"])
        XCTAssertNotNil(personSUI.id)
        print(personSUI.id)
    
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        personSUI = nil
        try super.tearDownWithError()
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
