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

    func testCommandForSigning() {
        let command = packageCommand.signingApk()
        let expected = "jarsigner -verbose -keystore ~/.android/debug.keystore -storepass android -keypass android " +
                       "-signedjar bin/App.signed.apk bin/App.unsigned.apk androiddebugkey"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandForZipAlign() {
        let command = packageCommand.zipAlign(buildTools: buildTools)
        let expected = "build-tools/zipalign -v -f 4 bin/App.signed.apk bin/App.apk"
        XCTAssertEqual(expected, command.join())
    }
}

#if os(Linux)
    extension PackageCommandTests {
        static var allTests = [
            ("testCommandForPackaging", testCommandForPackaging),
            ("testCommandForSigning", testCommandForSigning),
            ("testCommandForZipAlign", testCommandForZipAlign),
        ]
    }
#endif
