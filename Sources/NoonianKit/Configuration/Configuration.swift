//
//  Configuration.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

// TODO: Need to figure out how much of this is necessary???

enum ConfigurationItem: String {
    case beforeBuild = "before_build"
}

struct Configuration {
    let tasks: [CommandTask]

    init(configuration: [String: Any]) throws {
        let mapped = try Configuration.validateAndMap(configuration: configuration)
        var tasks = [CommandTask]()
        for (key, value) in mapped {
            tasks.append(try CommandTask(name: key.rawValue, configuration: value))
        }
        self.tasks = tasks
    }

    static func validateAndMap(configuration: [String: Any]) throws -> [ConfigurationItem: Any] {
        var mapped = [ConfigurationItem: Any]()
        var unknownKeys = [String]()

        for (key, value) in configuration {
            if let item = ConfigurationItem(rawValue: key) {
                mapped[item] = value
            } else {
                unknownKeys.append(key)
            }
        }

        if !unknownKeys.isEmpty { throw NoonianKitError.unknownConfigurationItems(items: unknownKeys) }

        return mapped
    }
}
