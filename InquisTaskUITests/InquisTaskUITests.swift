//
//  InquisTaskUITests.swift
//  InquisTaskUITests
//
//  Created by Hrvoje Vuković on 19.04.2022..
//

import XCTest

class InquisTaskUITests: XCTestCase {

    // Measure warm launch over 5 iterations (after one throw-away launch)
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric(waitUntilResponsive: true)]) {
            XCUIApplication().launch()
        }
    }
}
