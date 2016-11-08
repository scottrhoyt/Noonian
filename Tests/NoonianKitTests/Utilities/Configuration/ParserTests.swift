//
//  ParserTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import XCTest
@testable import NoonianKit

class ParserTests: XCTestCase {
    struct TestParser: Parser {
        func parse(contents: String) throws -> [String : Any] {
            return ["contents": contents]
        }
    }

    let parser = TestParser()

    func testLoadFile() {
        let contents = try? parser.loadFile(at: pathForFixture(named: "test.txt"))
        let comp = "hello\nworld\n"
        XCTAssertEqual(contents, comp)
    }

    func testParseFile() {
        let parsed = try? parser.parseFile(at: pathForFixture(named: "test.txt"))
        let comp = "hello\nworld\n"
        XCTAssertEqual(parsed?["contents"] as? String, comp)
    }
}

#if os(Linux)
    extension ParserTests {
        static var allTests = [
            ("testLoadFile", testLoadFile),
            ("testParseFile", testParseFile),
        ]
    }
#endif
