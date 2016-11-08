//
//  NoonianConfigurationTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class NoonianConfigurationTests: XCTestCase {
    var configuration: NoonianConfiguration!

    override func setUp() {
        super.setUp()
        configuration = try? NoonianConfiguration(configFile: pathForFixture(named: "test.noonian.yml"))
    }

    func testBuildTools() {
        let buildTools = configuration.buildTools()
        let expected = "25.0.0"
        XCTAssertEqual(buildTools, expected)
    }

    func testBadTypeThrows() {
        do {
            let _: String = try configuration.value(for: "target")
        } catch NoonianKitError.cannotReadConfiguration(let key, _) {
            XCTAssertEqual(key, "target")
            return
        } catch {
            XCTFail("Should have thrown a cannotReadConfiguration error")
        }

        XCTFail("Should have thrown an error")
    }

    func testMissingValueThrows() {
        do {
            let _: String = try configuration.value(for: "not there")
        } catch NoonianKitError.missingConfiguration(let key) {
            XCTAssertEqual(key, "not there")
            return
        } catch {
            XCTFail("Should have thrown a missingConfiguration error")
        }

        XCTFail("Should have thrown an error")
    }

    func testThrowsIfNoConfigurationFile() {
        do {
            _ = try NoonianConfiguration()
        } catch {
            return
        }

        XCTFail("Should have thrown an error.")
    }

    func testAppName() {
        XCTAssertEqual(configuration.appName(), "app")
    }

    func testConfiguredValue() {
        let task1: CommandTask? = try? configuration.configuredValue(for: "before_test")
        let task2 = CommandTask(name: "before_test", commands: ["a", "b"])
        XCTAssertEqual(task1, task2)
    }
}

#if os(Linux)
    extension NoonianConfigurationTests {
        static var allTests = [
            ("testBuildTools", testBuildTools),
            ("testBadTypeThrows", testBadTypeThrows),
            ("testMissingValueThrows", testMissingValueThrows),
            ("testThrowsIfNoConfigurationFile", testThrowsIfNoConfigurationFile),
            ("testAppName", testAppName),
            ("testConfiguredValue", testConfiguredValue),
        ]
    }
#endif
