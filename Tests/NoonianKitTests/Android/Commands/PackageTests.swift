//
//  PackageTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class PackageTests: XCTestCase {
    let package = Package()
    let buildTools = "build-tools"
    let target = "target"

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testCommandForPackaging() {
        let command = package.packagingApk(packageTool: "aapt", include: "include")
        let expected = "aapt package -v -f -M AndroidManifest.xml -S res -I include -F bin/App.unsigned.apk bin"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandForSigning() {
        let command = package.signingApk()
        let expected = "jarsigner -verbose -keystore ~/.android/debug.keystore -storepass android -keypass android " +
                       "-signedjar bin/App.signed.apk bin/App.unsigned.apk androiddebugkey"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandForZipAlign() {
        let command = package.zipAlign(zipTool: "zipalign")
        let expected = "zipalign -v -f 4 bin/App.signed.apk bin/App.apk"
        XCTAssertEqual(expected, command.join())
    }
}

#if os(Linux)
    extension PackageTests {
        static var allTests = [
            ("testCommandForPackaging", testCommandForPackaging),
            ("testCommandForSigning", testCommandForSigning),
            ("testCommandForZipAlign", testCommandForZipAlign),
        ]
    }
#endif
