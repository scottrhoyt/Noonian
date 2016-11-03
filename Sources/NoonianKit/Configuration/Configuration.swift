//
//  Configuration.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

struct Configuration {
    static let allowedItems: Set<String> = [
        "before_build"
    ]
    let tasks: [CommandTask]

    init(configuration: [String: Any]) throws {
        try Configuration.checkAllKeysAllowed(keys: Set(configuration.keys))
        tasks = [try CommandTask(name: "before_build", configuration: configuration["before_build"]!)]
    }

    static func checkAllKeysAllowed(keys: Set<String>) throws {
        let unknownKeys = keys.subtracting(allowedItems)
        if !unknownKeys.isEmpty {
            throw NoonianError.unknownConfigurationItems(items: unknownKeys)
        }
    }
}
