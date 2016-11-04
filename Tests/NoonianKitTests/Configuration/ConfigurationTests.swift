//
//  ConfigurationTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class ConfigurationTests: XCTestCase {
    func testBadConfigurationItemsThrows() {
        let badConfig = [
            "badItem1": 1,
            "badItem2": 2
        ]

        do {
            _ = try Configuration(configuration: badConfig)
        } catch NoonianError.unknownConfigurationItems(items: let items) {
            XCTAssertEqual(items, Array(badConfig.keys))
            return
        } catch {
            XCTFail(
                "Should have thrown an unknownConfigurationItems error.\n" +
                "Instead threw: \(error)"
            )
        }

        XCTFail("Should have thrown an error.")
    }

    func testBeforeBuildConfig() {
        let config = [
            "before_build": ["foo", "bar"]
        ]
        do {
            let configuration = try Configuration(configuration: config)
            let task = CommandTask(name: "before_build", commands: ["foo", "bar"])
            XCTAssertEqual(configuration.tasks.count, 1)
            XCTAssertEqual(configuration.tasks.first, task)

        } catch {
            XCTFail("Should not have thrown error: \(error)")
        }
    }
}

#if os(Linux)
    extension ConfigurationTests {
        static var allTests = [
            ("testBadConfigurationItemsThrows", testBadConfigurationItemsThrows),
            ("testBeforeBuildConfig", testBeforeBuildConfig)
        ]
    }
#endif
