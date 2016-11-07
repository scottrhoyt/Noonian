//
//  BuildCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class BuildCommandTests: XCTestCase {

    let build = BuildCommand()
    let buildTools = "build-tools"
    let target = "android"

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testCommandForCompile() {
        let command = try? build.compiling(buildTools: buildTools, target: target)
        let expectedStatement = "java -jar \(buildTools)/jack.jar --verbose info -cp /platforms/\(target)/android.jar --output-dex bin src"
        XCTAssertEqual(expectedStatement, command?.join())
    }

    func testCommandForPackageResources() {
        let command = try? build.packagingResources(buildTools: buildTools, target: target)
        let expectedStatement = "\(buildTools)/aapt package -v -f -m -S res -J src -M AndroidManifest.xml -I /platforms/\(target)/android.jar"
        XCTAssertEqual(expectedStatement, command?.join())
    }
}

#if os(Linux)
    extension BuildCommandTests {
        static var allTests = [
            ("testCommandForCompile", testCommandForCompile),
            ("testCommandForPackageResources", testCommandForPackageResources),
        ]
    }
#endif
