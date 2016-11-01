//
//  NothingTests.swift
//  noonian
//
//  Created by Scott Hoyt on 10/31/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import noonian

class NothingTests: XCTestCase {
    func testAlwaysPasses() { }
}

#if os(Linux)
extension NothingTests {
    static var allTests = [
        ("testAlwaysPasses", testAlwaysPasses)
    ]
}
#endif
