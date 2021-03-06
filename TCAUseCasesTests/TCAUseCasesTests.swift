//
//  TCAUseCasesTests.swift
//  TCAUseCasesTests
//
//  Created by MD AL MAMUN on 2020-05-27.
//  Copyright © 2020 MD AL MAMUN. All rights reserved.
//

import XCTest
@testable import TCAUseCases

class TCAUseCasesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testVerticalStateIsIdempotent() throws {
        var state = CollectionState(collection: .one)
        state.items = [.init(title: "one")]
        state.isNavigationActive = true
        XCTAssertNotNil(state.verticalState)
        XCTAssertEqual(state.verticalState, state.verticalState)
    }

}
