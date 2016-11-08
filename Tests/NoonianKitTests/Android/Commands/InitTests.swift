//
//  InitCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit
import Commandant
import Result

class InitCommandTests: XCTestCase {
    let initCommand = Init()

    override func setUp() {
        super.setUp()
        clearAndroidHome()
    }

    func testOptionsDefaults() {
        let projectName = "projectName"
        let options = InitOptions(path: nil, activity: nil, target: nil, package: nil, projectName: projectName)
        XCTAssertEqual(options.path, projectName)
        XCTAssertEqual(options.activity, "Main")
        XCTAssertEqual(options.target, "android-25")
        XCTAssertEqual(options.package, "com.example." + projectName)
        XCTAssertEqual(options.projectName, projectName)
    }

    func testCommandForProjectCreation() {
        let options = InitOptions(
            path: "path",
            activity: "activity",
            target: "android",
            package: "package",
            projectName: "projectName"
        )

        let command = initCommand.projectCreation(options: options, androidTool: "android")
        let expected = "android create project -a activity -p path -t android -k package -n projectName"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandForCopyingConfig() {
        let projectPath = "projectPath"
        let command = initCommand.copyingExampleConfig(projectPath: projectPath)

        let expected = "cp /usr/local/share/noonian/example.noonian.yml \(projectPath)/.noonian.yml"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandToAddTarger() {
        let projectPath = "projectPath"
        let contents = "key: value"
        let command = initCommand.addingStringToConfig(contents: contents, projectPath: projectPath)

        let expected = "echo key: value >> projectPath/.noonian.yml"
        XCTAssertEqual(expected, command.join())
    }

    func testOptionsFullySpecified() {
        let arguments = ["--path", "pathName", "--activity", "activityName", "--package", "packageName", "--target", "targetName", "projectName"]
        switch InitOptions.evaluate(.arguments(ArgumentParser(arguments))) {
        case .success(let options):
            XCTAssertEqual(options.activity, "activityName")
            XCTAssertEqual(options.package, "packageName")
            XCTAssertEqual(options.path, "pathName")
            XCTAssertEqual(options.projectName, "projectName")
            XCTAssertEqual(options.target, "targetName")
        default:
            XCTFail()
        }
    }

    func testOptionsMinimallySpecified() {
        let arguments = ["projectName"]
        switch InitOptions.evaluate(.arguments(ArgumentParser(arguments))) {
        case .success(let options):
            XCTAssertEqual(options.activity, "Main")
            XCTAssertEqual(options.package, "com.example.projectName")
            XCTAssertEqual(options.path, "projectName")
            XCTAssertEqual(options.projectName, "projectName")
            XCTAssertEqual(options.target, "android-25")
        default:
            XCTFail()
        }
    }
}

extension XCTestCase {
    func clearAndroidHome() {
        Environment().set(value: "", for: "ANDROID_HOME")
    }
}

#if os(Linux)
    extension InitCommandTests {
        static var allTests = [
            ("testOptionsDefaults", testOptionsDefaults),
            ("testCommandForProjectCreation", testCommandForProjectCreation),
            ("testCommandForCopyingConfig", testCommandForCopyingConfig),
            ("testCommandToAddTarger", testCommandToAddTarger),
            ("testOptionsFullySpecified", testOptionsFullySpecified),
            ("testOptionsMinimallySpecified", testOptionsMinimallySpecified),
        ]
    }
#endif
