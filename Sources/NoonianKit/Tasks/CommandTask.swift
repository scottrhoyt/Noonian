//
//  BeforeBuildTask.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public typealias Arguement = (flag: String, value: String?)
public typealias CommandWithArguments = (command: String, arguments: [Arguement])

public struct CommandTask: ConfigurableTask, Equatable {
    let name: String
    let commands: [String]

    public init(name: String, commands: [String]) {
        self.name = name
        self.commands = commands
    }

    // FIXME: Rewite this to be more functional
    public init(name: String, commandsWithArgs: [CommandWithArguments]) {
        var builtCommands = [String]()
        for (command, arguements) in commandsWithArgs {
            var builtCommand = command
            for (flag, value) in arguements {
                if let value = value {
                    builtCommand += " " + flag + " " + value
                } else {
                    builtCommand += " " + flag
                }
            }
            builtCommands.append(builtCommand)
        }
        self.init(name: name, commands: builtCommands)
    }
}

// MARK: - CommandTask: Equatable

public func == (lhs: CommandTask, rhs: CommandTask) -> Bool {
    return lhs.name == rhs.name &&
        lhs.commands == rhs.commands
}
