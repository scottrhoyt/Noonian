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
        let contents = loadFixture(named: "test.txt")
        let comp = "hello\nworld\n"
        XCTAssertEqual(contents, comp)
    }
}
