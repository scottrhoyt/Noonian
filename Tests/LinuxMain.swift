#if os(Linux)
import XCTest

@testable import NoonianTests

XCTMain([
  testCase(NothingTests.allTests),
  testCase(BeforeBuildTaskTests.allTests)
])
#endif
