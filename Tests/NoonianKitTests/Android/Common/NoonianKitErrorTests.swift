//
//  UtilityErrorTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/7/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class NoonianKitErrorTests: XCTestCase {
    func testNSErrorHasExplanation() {
        let error = NSError(domain: "com.test", code: 0, userInfo: [NSLocalizedDescriptionKey: "explanation"])
        XCTAssertEqual(error.explanation, "explanation")
    }

    func testWrappedUtilityError() {
        let error = NoonianKitError.internalError(UtilityError.taskFailed(taskName: "task", command: "command"))
        XCTAssertEqual(error.explanation, "task failed at command: command")
    }
}

#if os(Linux)
    extension NoonianKitErrorTests {
        static var allTests = [
            ("testNSErrorHasExplanation", testNSErrorHasExplanation),
            ("testWrappedUtilityError", testWrappedUtilityError),
        ]
    }
#endif
