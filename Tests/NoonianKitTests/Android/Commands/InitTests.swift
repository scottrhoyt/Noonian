//
//  InitCommandTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

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

        let command = try? initCommand.projectCreation(options: options, androidTool: "android")
        let expected = "android create project -a activity -p path -t android -k package -n projectName"
        XCTAssertEqual(expected, command?.join())
    }

    func testCommandForCopyingConfig() {
        let projectPath = "projectPath"
        let command = initCommand.copyingExampleConfig(projectPath: projectPath)

        let expected = "cp /usr/local/lib/noonian/example.noonian.yml \(projectPath)/.noonian.yml"
        XCTAssertEqual(expected, command.join())
    }

    func testCommandToAddTarger() {
        let projectPath = "projectPath"
        let target = "target"
        let command = initCommand.addingTargetToConfig(target: target, projectPath: projectPath)

        let expected = "echo target: target >> projectPath/.noonian.yml"
        XCTAssertEqual(expected, command.join())
    }
    // TODO: Need to test options building
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
        ]
    }
#endif
