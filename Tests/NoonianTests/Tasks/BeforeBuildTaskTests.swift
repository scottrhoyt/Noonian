//
//  BeforeBuildTaskTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import noonian

class BeforeBuildTaskTests: XCTestCase {
    func testInitWithCommands() {
        let commands = [
            "cp foo bar",
            "cp bar baz"
        ]
        let task = BeforeBuildTask(commands: commands)
        XCTAssertEqual(commands, task.commands)
    }
}

#if os(Linux)
    extension BeforeBuildTaskTests {
        static var allTests = [
            ("testInitWithCommands", testInitWithCommands)
        ]
    }
#endif
