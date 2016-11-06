//
//  ShellCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public struct ShellArgument {
    let flag: String
    let values: [String]?

    public init(_ flag: String) {
        self.flag = flag
        self.values = nil
    }

    public init(_ flag: String, _ values: String...) {
        self.flag = flag
        self.values = values
    }

    fileprivate func join() -> String {
        let values = self.values ?? []
        return ([flag] + values).joined(separator: " ")
    }
}

public struct ShellCommand {
    let command: String
    let arguments: [ShellArgument]?

    public init(command: String, arguments: [ShellArgument]? = nil) {
        self.command = command
        self.arguments = arguments
    }

    internal func join() -> String {
        let joinedArguments = arguments?.map { $0.join() } ?? []
        return ([command] + joinedArguments).joined(separator: " ")
    }
}
