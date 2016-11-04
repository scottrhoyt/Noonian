//
//  Runner.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

struct Runner {
    let out: Pipe?
    let error: Pipe?

    init(out: Pipe? = nil, error: Pipe? = nil) {
        self.out = out
        self.error = error
    }

    func run(task: CommandTask) {
        for command in task.commands {
            let process = newProcess(command: command)
            process.launch()
            process.waitUntilExit()
        }
    }

    private func newProcess(command: String) -> Process {
        let process = Process()

        if let out = out {
            process.standardOutput = out
        }

        if let error = error {
            process.standardError = error
        }

        process.launchPath = "/bin/sh"
        process.arguments = [
            "-c",
            command
        ]
        return process
    }
}
