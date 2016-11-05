//
//  NSString+NoonianKitTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import XCTest
import NoonianKit

class StringNoonianKitTests: XCTestCase {
    func testAbsolutionPath() {
        XCTAssertTrue("/home".isAbsolutePath)
        XCTAssertFalse("home".isAbsolutePath)
    }

    func testAddPathComponent() {
        XCTAssertEqual("/home/noonian", "/home".pathByAdding(component: "noonian"))
        XCTAssertEqual("/home/noonian", "/home".pathByAdding(component: "/noonian"))
        XCTAssertEqual("/home/noonian", "/home/".pathByAdding(component: "/noonian"))
    }

    func testAbsolutePath() {
        let currentDir = FileManager.default.currentDirectoryPath
        XCTAssertEqual("/home".absolutePathRepresentation(), "/home")
        XCTAssertEqual("home".absolutePathRepresentation(), currentDir.pathByAdding(component: "home"))
    }
}

#if os(Linux)
    extension StringNoonianKitTests {
        static var allTests = [
            ("testAbsolutionPath", testAbsolutionPath),
            ("testAddPathComponent", testAddPathComponent),
            ("testAbsolutePath", testAbsolutePath),
        ]
    }
#endif
