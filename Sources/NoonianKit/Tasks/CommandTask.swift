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
        self.init(name: name, commands: commands.map(assemble))
    }
}

// MARK: - CommandTask: Equatable

public func == (lhs: CommandTask, rhs: CommandTask) -> Bool {
    return lhs.name == rhs.name &&
        lhs.commands == rhs.commands
}

// MARK: - ShellCommand

// TODO: rewrite these as structures so syntax can be better for no value and arguments
public typealias ShellArgument = (flag: String, value: String?)
public typealias ShellCommand = (command: String, arguments: [ShellArgument])

fileprivate func join(argument: ShellArgument) -> String {
    return [argument.flag, argument.value].flatMap { $0 }.joined(separator: " ")
}

// TODO: Need to make this fileprivate again
public func assemble(command: ShellCommand) -> String {
    return command.command + " " + command.arguments.map(join).joined(separator: " ")
}
