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
        } catch NoonianKitError.unknownConfigurationOption(let name, let option) {
            XCTAssertEqual(commandName, name)
            XCTAssertEqual(badConfig, option as? Int)
            return
        } catch {
            XCTFail("Should have caught an unknownConfigurationOption Error")
        }
        XCTFail("Should have caught an error")
    }

    func testBuildCommandsWithArguements() {
        let arg1 = ShellArgument(flag: "-a", value: nil)
        let arg2 = ShellArgument(flag: "-b", value: "c")
        let command = ShellCommand(command: "cp", arguments: [arg1, arg2])
        let task = CommandTask(name: commandName, commands: [command])
        XCTAssertEqual(task.name, commandName)
        XCTAssertEqual(task.commands, ["cp -a -b c"])
    }
}

#if os(Linux)
    extension CommandTaskTests {
        static var allTests = [
            ("testInitWithCommands", testInitWithCommands),
            ("testInitWithStringConfiguration", testInitWithStringConfiguration),
            ("testInitWithArrayConfiguration", testInitWithArrayConfiguration),
            ("testInitWithBadConfigurationThrows", testInitWithBadConfigurationThrows),
            ("testBuildCommandsWithArguements", testBuildCommandsWithArguements),
        ]
    }
#endif
