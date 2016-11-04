//
//  BeforeBuildTask.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

struct CommandTask: ConfigurableTask, Equatable {
    let name: String
    let commands: [String]

    init(name: String, commands: [String]) {
        self.name = name
        self.commands = commands
    }
}

// MARK: - CommandTask: Equatable

func == (lhs: CommandTask, rhs: CommandTask) -> Bool {
    return lhs.name == rhs.name &&
        lhs.commands == rhs.commands
}
