#if os(Linux)
import XCTest

@testable import NoonianKitTests

XCTMain([
    testCase(CommandTaskTests.allTests),
    testCase(ConfigurationTests.allTests),
    testCase(RunnerTests.allTests),
    testCase(ParserTests.allTests),
    testCase(YamlParserTests.allTests),
    testCase(EnvironmentTests.allTests),
    testCase(StringNoonianKitTests.allTests),

    // MARK: Android specifiv
    testCase(BuildCommandTests.allTests),
    testCase(InitCommandTests.allTests),
])
#endif
