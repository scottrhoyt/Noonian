//
//  YamlParserTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import XCTest
@testable import NoonianKit

class YamlParserTests: XCTestCase {
    let parser = YamlParser()

    func testDuplicateKeysThrows() {
        let contents = "item1: value\n" +
                       "item1: value"
        do {
            _ = try parser.parse(contents: contents)
        } catch NoonianKitError.configurationParsing {
            return
        } catch {
            XCTFail(
                "Should have thrown an configurationParsing error.\n" +
                "Instead threw: \(error)"
            )
        }
        XCTFail("Should have thrown an error")
    }

    func testInvalidConfigurationThrows() {
        let contents = "2"
        do {
            _ = try parser.parse(contents: contents)
        } catch NoonianKitError.invalidConfiguration {
            return
        } catch {
            XCTFail(
                "Should have thrown an invalidConfiguration error.\n" +
                "Instead threw: \(error)"
            )
        }
        XCTFail("Should have thrown an error")
    }

    func testParseYaml() {
        guard let parsed = try? parser.parse(contents: loadFixture(named: "test.yml")) else {
            XCTFail("Error Thrown")
            return
        }

        let dict1 = (parsed["dictionary1"] as? [String : Any])!
        let dict2 = (parsed["dictionary2"] as? [String : Any])!
        XCTAssertTrue(dict1["bool"] as? Bool == true && dict2["bool"] as? Bool == true)
        XCTAssertTrue(dict1["int"] as? Int == 1 && dict2["int"] as? Int == 1)
        XCTAssertTrue(dict1["double"] as? Double == 1.0 && dict2["double"] as? Double == 1.0)
        XCTAssertTrue(dict1["string"] as? String == "string" &&
            dict2["string"] as? String == "string")

        let array1 = (dict1["array"] as? [Any])!
        let array2 = (dict1["array"] as? [Any])!
        XCTAssertTrue(array1[0] as? Bool == true && array2[0] as? Bool == true)
        XCTAssertTrue(array1[1] as? Int == 1 && array2[1] as? Int == 1)
        XCTAssertTrue(array1[2] as? Double == 1.0 && array2[2] as? Double == 1.0)
        XCTAssertTrue(array1[3] as? String == "string" && array2[3] as? String == "string")

        let dict1_1 = (array1[4] as? [String: Any])!
        let dict2_2 = (array2[4] as? [String: Any])!
        XCTAssertTrue(dict1_1["bool"] as? Bool == true && dict2_2["bool"] as? Bool == true)
        XCTAssertTrue(dict1_1["int"] as? Int == 1 && dict2_2["int"] as? Int == 1)
        XCTAssertTrue(dict1_1["double"] as? Double == 1.0 &&
            dict2_2["double"] as? Double == 1.0)
        XCTAssertTrue(dict1_1["string"] as? String == "string" &&
            dict2_2["string"] as? String == "string")
    }
}

#if os(Linux)
    extension YamlParserTests {
        static var allTests = [
            ("testDuplicateKeysThrows", testDuplicateKeysThrows),
            ("testInvalidConfigurationThrows", testInvalidConfigurationThrows),
            ("testParseYaml", testParseYaml),
        ]
    }
#endif
