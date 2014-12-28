//
//  Goodpasture_SwiftTests.swift
//  Goodpasture_SwiftTests
//
//  Created by Phillip Trent on 12/25/14.
//  Copyright (c) 2014 Phillip Trent. All rights reserved.
//

import Foundation
import UIKit
import XCTest

class HomeModelTests: XCTestCase {
    let model: HomeModel = HomeModel()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNames() {
        XCTAssertEqual(model.sports.name, "#Sports", "Test Sports Name")
        XCTAssertEqual(model.calendar.name, "Calendar", "Test Calendar Name")
        XCTAssertEqual(model.media.name, "Media", "Test Media Name")
        XCTAssertEqual(model.grades.name, "Grades", "Test Grades Name")
        XCTAssertEqual(model.about.name, "About", "Test About Name")
    }
    
}
