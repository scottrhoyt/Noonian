#if os(Linux)
import XCTest

@testable import NoonianKitTests

XCTMain([
  testCase(CommandTaskTests.allTests),
  testCase(ConfigurationTests.allTests)
])
#endif
