#if os(Linux)
import XCTest

@testable import NoonianKitTests

XCTMain([
  testCase(CommandTaskTests.allTests),
  testCase(ConfigurationTests.allTests),
  testCase(RunnerTests.allTests),
  testCase(ParserTests.allTests),
  testCase(YamlParserTests.allTests),
])
#endif
