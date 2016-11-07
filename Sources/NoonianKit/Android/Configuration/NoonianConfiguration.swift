//
//  NoonianConfiguration.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

enum ConfigurationKeys: String {
    case buildTools = "build_tools"
    case target = "target"
}

//protocol AnyConfigurable {
//    init(config: Any) throws
//}

struct NoonianConfiguration {
    private static let defaultFileName = ".noonian.yml"
    private let configs: [String: Any]

    // TODO: allow this to be configured.
    init() throws {
        let parser = YamlParser()
        configs = try parser.parseFile(at: NoonianConfiguration.defaultFileName)
    }

    func buildTools() -> String? {
        return (try? value(for: ConfigurationKeys.buildTools.rawValue)) as? String
    }

    func value(for key: String) throws -> Any {
        guard let val = configs[key] else {
            throw NoonianError.missingConfiguration(key: key)
        }

        return val
    }
}
