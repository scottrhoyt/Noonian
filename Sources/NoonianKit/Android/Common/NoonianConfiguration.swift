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
    case appName = "app_name"
}

//protocol AnyConfigurable {
//    init(config: Any) throws
//}

struct NoonianConfiguration {
    static let defaultAppName = "App"
    static let defaultFileName = ".noonian.yml"
    private let configs: [String: Any]

    init(configFile: String? = nil) throws {
        let parser = YamlParser()
        configs = try parser.parseFile(at: configFile ?? NoonianConfiguration.defaultFileName)
    }

    func buildTools() -> String? {
        return try? value(for: ConfigurationKeys.buildTools.rawValue)
    }

    func target() throws -> String {
        return try value(for: ConfigurationKeys.target.rawValue)
    }

    func appName() -> String {
        return (try? value(for: ConfigurationKeys.appName.rawValue)) ?? NoonianConfiguration.defaultAppName
    }

    func value<T>(for key: String) throws -> T {
        guard let val = configs[key] else {
            throw NoonianKitError.missingConfiguration(key: key)
        }

        if let val = val as? T {
            return val
        }

        throw NoonianKitError.cannotReadConfiguration(key: key, type: T.self)
    }
}
