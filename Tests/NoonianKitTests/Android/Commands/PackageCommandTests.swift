//
//  PackageCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class PackageCommandTests: XCTestCase {

    let packageCommand = PackageCommand()
    let buildTools = "build-tools"
    let target = "target"

    func testCommandForPackaging() {
        let command = try? packageCommand.packagingApk(buildTools: buildTools, target: target)
        let expected = "build-tools/aapt package -v -f -M AndroidManifest.xml -S res -I /platforms/target/android.jar -F bin/App.unsigned.apk bin"
        XCTAssertEqual(expected, command?.join())
    }

}

#if os(Linux)
    extension PackageCommandTests {
        static var allTests = [
            ("testCommandForPackaging", testCommandForPackaging),
        ]
    }
#endif
