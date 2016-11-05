//
//  EnvironmentTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
import NoonianKit

class EnvironmentTests: XCTestCase {
    func testEnvironment() {
        let key = "NOONIAN_KIT_TEST_KEY"
        let value = "test"
        let env = Environment()

        env.unset(for: key)
        env.set(value: value, for: key)
        XCTAssertEqual(env.stringValue(for: key), value)

        env.unset(for: key)
        XCTAssertNil(env.stringValue(for: key))
    }
}

#if os(Linux)
    extension EnvironmentTests {
        static var allTests = [
            ("testEnvironment", testEnvironment),
        ]
    }
#endif
