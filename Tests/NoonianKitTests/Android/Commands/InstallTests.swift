//
//  InstallTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class InstallTests: XCTestCase {
    let install = Install()
    let appName = "app"

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testCommandForInstall() {
        let command = install.install(adbTool: "adb", appName: appName)
        let expected = "adb install -r bin/app.apk"
        XCTAssertEqual(expected, command.join())
    }
}

#if os(Linux)
    extension InstallTests {
        static var allTests = [
            ("testCommandForInstall", testCommandForInstall),
        ]
    }
#endif
