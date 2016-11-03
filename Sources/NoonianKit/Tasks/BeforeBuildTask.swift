//
//  BeforeBuildTask.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

struct BeforeBuildTask: Task {
    let commands: [String]

    init(commands: [String]) {
        self.commands = commands
    }

    func run() {
        fatalError()
    }
}
