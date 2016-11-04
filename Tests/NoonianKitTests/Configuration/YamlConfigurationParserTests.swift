//
//  YamlConfigurationParserTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import XCTest
@testable import NoonianKit

class YamlConfigurationParserTests: XCTestCase {
    let parser = YamlConfigurationParser()

    func testLoadFile() {

    }
}

extension XCTestCase {
    func pathToFixtures() -> String {
        let fileManager = FileManager.default
        let workingDir = fileManager.currentDirectoryPath
        return workingDir + "Tests/NoonianKitTests/Fixtures"
    }
}
