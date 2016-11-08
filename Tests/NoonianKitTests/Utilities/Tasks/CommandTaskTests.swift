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
            XCTAssertEqual(task, CommandTask(name: commandName, commands: [stringCommand]))
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func testInitWithArrayConfiguration() {
        do {
            let task = try CommandTask(name: commandName, configuration: arrayCommands)
            XCTAssertEqual(task, CommandTask(name: commandName, commands: arrayCommands))
        } catch {
            XCTFail("Should not throw an error")
        }
    }

    func testInitWithBadConfigurationThrows() {
        let badConfig = 1
        do {
            _ = try CommandTask(name: commandName, configuration: badConfig)
        } catch UtilityError.cannotConfigure(let item, let with) {
            XCTAssertEqual(commandName, item)
            XCTAssertEqual(badConfig, with as? Int)
            return
        } catch {
            XCTFail("Should have caught an unknownConfigurationOption Error")
        }
        XCTFail("Should have caught an error")
    }

    func testBuildCommandsWithArguements() {
        let arg1 = ShellArgument("action")
        let arg2 = ShellArgument("-b", "c")
        let arg3 = ShellArgument("-d", "e", "f")
        let command = ShellCommand(command: "command", arguments: [arg1, arg2, arg3])
        let task = CommandTask(name: commandName, commands: [command])
        XCTAssertEqual(task.name, commandName)
        XCTAssertEqual(task.commands, ["command action -b c -d e f"])
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
