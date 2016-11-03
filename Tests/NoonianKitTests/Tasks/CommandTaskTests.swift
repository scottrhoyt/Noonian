//
//  BeforeBuildTaskTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class CommandTaskTests: XCTestCase {
    let commandName = "command"
    let stringCommand = "cp foo bar"
    let arrayCommands = [
        "cp foo bar",
        "cp bar baz"
    ]

    func testInitWithCommands() {
        let task = CommandTask(name: commandName, commands: arrayCommands)
        XCTAssertEqual(commandName, task.name)
        XCTAssertEqual(arrayCommands, task.commands)
    }

    func testInitWithStringConfiguration() {
        do {
            let task = try CommandTask(name: commandName, configuration: stringCommand)
            XCTAssertEqual(commandName, task.name)
            XCTAssertEqual([stringCommand], task.commands)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func testInitWithArrayConfiguration() {
        do {
            let task = try CommandTask(name: commandName, configuration: arrayCommands)
            XCTAssertEqual(commandName, task.name)
            XCTAssertEqual(arrayCommands, task.commands)
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func testInitWithBadConfigurationThrows() {
        let badConfig = 1
        do {
            _ = try CommandTask(name: commandName, configuration: badConfig)
        } catch ConfigurationError.unknownConfiguration {
            return
        } catch {
            XCTFail("Should have caught an unknownConfiguration Error")
        }
        XCTFail("Should have caught an error")
    }
}

#if os(Linux)
    extension CommandTaskTests {
        static var allTests = [
            ("testInitWithCommands", testInitWithCommands),
            ("testInitWithStringConfiguration", testInitWithStringConfiguration),
            ("testInitWithArrayConfiguration", testInitWithArrayConfiguration),
            ("testInitWithBadConfigurationThrows", testInitWithBadConfigurationThrows),
        ]
    }
#endif
