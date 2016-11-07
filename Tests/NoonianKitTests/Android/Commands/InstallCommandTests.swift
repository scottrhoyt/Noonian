//
//  InstallCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class InstallCommandTests: XCTestCase {
    let installCommand = InstallCommand()

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testCommandForInstall() {
        let command = try? installCommand.install()
        let expected = "/platform-tools/adb install bin/App.apk"
        XCTAssertEqual(expected, command?.join())
    }
}

#if os(Linux)
    extension InstallCommandTests {
        static var allTests = [
            ("testCommandForInstall", testCommandForInstall),
        ]
    }
#endif
