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

    public init(name: String, commands: [Command]) {
        self.init(name: name, commands: commands.map(join))
    }
}

// MARK: - CommandTask: Equatable

public func == (lhs: CommandTask, rhs: CommandTask) -> Bool {
    return lhs.name == rhs.name &&
        lhs.commands == rhs.commands
}

// MARK: - Command

// TODO: Might want to rename these to not be too similar to Commandant (e.g. ShellCommand)
public typealias CommandArgument = (flag: String, value: String?)
public typealias Command = (command: String, arguments: [CommandArgument])

fileprivate func join(argument: CommandArgument) -> String {
    return [argument.flag, argument.value].flatMap { $0 }.joined(separator: " ")
}

fileprivate func join(command: Command) -> String {
    return command.command + " " + command.arguments.map(join).joined(separator: " ")
}
