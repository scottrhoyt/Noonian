//
//  Configuration.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

enum ConfigurationItem: String {
    case beforeBuild = "before_build"

    static var allItems: Set<ConfigurationItem> {
        return [.beforeBuild]
    }
}

struct Configuration {
    let tasks: [CommandTask]

    init(configuration: [String: Any]) throws {
        try Configuration.checkAllKeysAllowed(keys: Set(configuration.keys))
        var tasks = [CommandTask]()
        for (key, value) in configuration {
            tasks.append(try CommandTask(name: key, configuration: value))
        }
        self.tasks = tasks
    }

    static func checkAllKeysAllowed(keys: Set<String>) throws {
        let unknownKeys = keys.subtracting(ConfigurationItem.allItems.map { $0.rawValue })
        if !unknownKeys.isEmpty {
            throw NoonianError.unknownConfigurationItems(items: unknownKeys)
        }
    }
}
