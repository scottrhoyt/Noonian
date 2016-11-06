//
//  BeforeBuildTask.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public struct CommandTask: ConfigurableTask, Equatable {
    let name: String
    let commands: [String]

    public init(name: String, commands: [String]) {
        self.name = name
        self.commands = commands
    }

    public init(name: String, commands: [ShellCommand]) {
        self.init(name: name, commands: commands.map { $0.join() })
    }
}

// MARK: - CommandTask: Equatable

public func == (lhs: CommandTask, rhs: CommandTask) -> Bool {
    return lhs.name == rhs.name &&
        lhs.commands == rhs.commands
}
