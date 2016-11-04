//
//  RunnerTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation // Need this for Linux support
import XCTest
@testable import NoonianKit

class RunnerTests: XCTestCase {
    func testRunnerSimple() {
        let testTask = CommandTask(name: "test", commands: ["echo hello world"])
        let out = Pipe()
        let error = Pipe()
        let runner = Runner(out: out, error: error)
        runner.run(task: testTask)

        var output = [String]()
        let outData = out.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outData, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }

        var errors = [String]()
        let errorData = error.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errorData, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            errors = string.components(separatedBy: "\n")
        }

        XCTAssertEqual(output.count, 1)
        XCTAssertEqual(output[0], "hello world")

        XCTAssertEqual(errors.count, 1)
        XCTAssertEqual(errors[0], "")
    }

    func testRunnerComplex() {
        let testTask = CommandTask(
            name: "test",
            commands: [
                "touch \"test file.tmp\"",
                "mv \"test file.tmp\" /tmp/testFile.tmp",
                "mv /tmp/testFile.tmp testFile.tmp",
            ])
        let runner = Runner()
        runner.run(task: testTask)
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: "testFile.tmp"))

        // Clean up test files to not pollute subsequent tests
        try? fileManager.removeItem(atPath: "/tmp/testFile.tmp")
        try? fileManager.removeItem(atPath: "testFile.tmp")
        try? fileManager.removeItem(atPath: "test file.tmp")
    }
}

#if os(Linux)
    extension RunnerTests {
        static var allTests = [
            ("testRunnerSimple", testRunnerSimple),
            ("testRunnerComplex", testRunnerComplex)
        ]
    }
#endif
