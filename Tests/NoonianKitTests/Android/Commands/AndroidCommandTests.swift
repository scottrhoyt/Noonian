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

    // MARK: - Mocks

    enum InternalError: Error {
        case someError
    }

    struct TestCommand: AndroidCommand {
        typealias Options = TestOptions
        let verb = "test"
        let function = "test"
        var error: Error?

        func run(_ options: TestOptions, paths: SDKPathBuilder) throws {
            if let error = error {
                throw error
            }
        }
    }

    struct TestOptions: OptionsProtocol {
        static func evaluate(_ m: CommandMode) -> Result<AndroidCommandTests.TestOptions, CommandantError<NoonianKitError>> {
            return .success(TestOptions())
        }
    }

    // MARK: - Tests

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testAndroidHomeNotDefinedThrows() {
        Environment().unset(for: "ANDROID_HOME")
        do {
            _ = try TestCommand().androidHome()
        } catch NoonianKitError.androidHomeNotDefined {
            return
        } catch {
            XCTFail("Should have thrown an androidHomeNotDefined")
        }

        XCTFail("Should have thrown an error")
    }

    func testRunSuccessfully() {
        let command = TestCommand()
        let result: Result<(), NoonianKitError> = command.run(TestOptions())
        switch result {
        case .success:
            return
        default:
            XCTFail("Should have been a success")
        }
    }

    func testRunWithNoonianError() {
        var command = TestCommand()
        command.error = NoonianKitError.androidHomeNotDefined
        let result: Result<(), NoonianKitError> = command.run(TestOptions())
        switch result {
        case .failure(NoonianKitError.androidHomeNotDefined):
            return
        default:
            XCTFail("Should have failed with a NoonianKitError")
        }
    }

    func testRunWithInternalError() {
        var command = TestCommand()
        command.error = InternalError.someError
        let result: Result<(), NoonianKitError> = command.run(TestOptions())
        switch result {
        case .failure(NoonianKitError.internalError(InternalError.someError)):
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
