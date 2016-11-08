//
//  BuildTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class BuildTests: XCTestCase {
    let build = Build()
    let buildTools = "build-tools"
    let target = "android"

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testCommandForCompile() {
        let command = build.compiling(jackTool: "java -jar jack.jar", include: "include")
        let expectedStatement = "java -jar jack.jar --verbose info -cp include --output-dex bin src"
        XCTAssertEqual(expectedStatement, command.join())
    }

    func testCommandForPackageResources() {
        let command = build.packagingResources(packageTool: "aapt", include: "include")
        let expectedStatement = "aapt package -v -f -m -S res -J src -M AndroidManifest.xml -I include"
        XCTAssertEqual(expectedStatement, command.join())
    }
}

#if os(Linux)
    extension BuildTests {
        static var allTests = [
            ("testCommandForCompile", testCommandForCompile),
            ("testCommandForPackageResources", testCommandForPackageResources),
        ]
    }
#endif
