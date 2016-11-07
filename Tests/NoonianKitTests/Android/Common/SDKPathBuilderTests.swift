//
//  SDKPathBuilderTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/7/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class SDKPathBuilderTests: XCTestCase {

    let androidHome = "androidHome"
    let toolsVersion = "0.0.0"
    let target = "android-0"
    var paths: SDKPathBuilder!

    override func setUp() {
        super.setUp()
        paths = SDKPathBuilder(androidHome: androidHome)
    }

    func testAndroidToolCommand() {
        XCTAssertEqual("\(androidHome)/tools/android", paths.androidToolCommand())
    }

    func testInclude() {
        XCTAssertEqual(
            "\(androidHome)/platforms/\(target)/android.jar",
            paths.includeFor(target: target)
        )
    }

    func testPackageToolCommand() {
        XCTAssertEqual(
            "\(androidHome)/build-tools/\(toolsVersion)/aapt",
            try? paths.packageToolCommand(toolsVersion: toolsVersion)
        )
    }

    func testJackToolCommand() {
        XCTAssertEqual(
            "java -jar \(androidHome)/build-tools/\(toolsVersion)/jack.jar",
            try? paths.jackToolCommand(toolsVersion: toolsVersion)
        )
    }

    func testZipAlignCommand() {
        XCTAssertEqual(
            "\(androidHome)/build-tools/\(toolsVersion)/zipalign",
            try? paths.zipAlignToolCommand(toolsVersion: toolsVersion)
        )
    }

    func testAdbToolCommand() {
        XCTAssertEqual(
            "\(androidHome)/platform-tools/adb",
            paths.adbToolCommand()
        )
    }
}

#if os(Linux)
    extension SDKPathBuilderTests {
        static var allTests = [
            ("testAndroidToolCommand", testAndroidToolCommand),
            ("testInclude", testInclude),
            ("testPackageToolCommand", testPackageToolCommand),
            ("testJackToolCommand", testJackToolCommand),
            ("testZipAlignCommand", testZipAlignCommand),
            ("testAdbToolCommand", testAdbToolCommand),
        ]
    }
#endif
