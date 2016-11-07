//
//  AndroidCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit
import Commandant
import Result

class AndroidCommandTests: XCTestCase {

    // MARK: Mocks

    struct TestCommand: AndroidCommand {
        typealias Options = TestOptions
        let verb = "test"
        let function = "test"
        var error: Error?

        func run(_ options: AndroidCommandTests.TestOptions) throws {
            if let error = error {
                throw error
            }
        }
    }

    struct TestOptions: OptionsProtocol {
        static func evaluate(_ m: CommandMode) -> Result<AndroidCommandTests.TestOptions, CommandantError<NoonianError>> {
            return .success(TestOptions())
        }
    }

    // MARK: Tests

    func testAndroidHomeNotDefinedThrows() {
        Environment().unset(for: "ANDROID_HOME")
        do {
            _ = try TestCommand().androidHome()
        } catch NoonianError.androidHomeNotDefined {
            return
        } catch {
            XCTFail("Should have thrown an androidHomeNotDefined")
        }

        XCTFail("Should have thrown an error")
    }

    func testRunSuccessfully() {
        let command = TestCommand()
        let result: Result<(), NoonianError> = command.run(TestOptions())
        switch result {
        case .success:
            return
        default:
            XCTFail("Should have been a success")
        }
    }

    func testRunWithNoonianError() {
        var command = TestCommand()
        command.error = NoonianError.androidHomeNotDefined
        let result: Result<(), NoonianError> = command.run(TestOptions())
        switch result {
        case .failure(NoonianError.androidHomeNotDefined):
            return
        default:
            XCTFail("Should have failed with a NoonianError")
        }
    }

    func testRunWithInternalError() {
        var command = TestCommand()
        command.error = NSError()
        let result: Result<(), NoonianError> = command.run(TestOptions())
        switch result {
        case .failure(NoonianError.internalError):
            return
        default:
            XCTFail("Should have failed with an internalError")
        }
    }
}

#if os(Linux)
    extension AndroidCommandTests {
        static var allTests = [
            ("testAndroidHomeNotDefinedThrows", testAndroidHomeNotDefinedThrows),
            ("testRunSuccessfully", testRunSuccessfully),
            ("testRunWithNoonianError", testRunWithNoonianError),
            ("testRunWithInternalError", testRunWithInternalError),
        ]
    }
#endif
