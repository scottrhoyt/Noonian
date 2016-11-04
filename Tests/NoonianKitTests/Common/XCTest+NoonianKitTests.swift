//
//  XCTest+NoonianKitTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    var fixturesPath: String {
        #if SWIFT_PACKAGE
            return "Tests/NoonianKitTests/Fixtures".absolutePathRepresentation()
        #else
            return Bundle(for: type(of: self)).resourcePath!
        #endif
    }

    func pathForFixture(named: String) -> String {
        return fixturesPath + "/" + named
    }

    func loadFixture(named: String) -> String {
        // swiftlint:disable:next force_try
        return try! String(contentsOfFile: pathForFixture(named: named), encoding: .utf8)
    }
}
