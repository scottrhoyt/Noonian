#if os(Linux)
import XCTest

@testable import NoonianKitTests

XCTMain([
  testCase(NothingTests.allTests),
  testCase(BeforeBuildTaskTests.allTests)
])
#endif
