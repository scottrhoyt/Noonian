//
//  Runner.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

#if os(Linux)
typealias Process = Foundation.Task
#endif

public struct Runner {
    let out: Pipe?
    let error: Pipe?

    public init() {
        self.init(out: nil, error: nil)
    }

    // This is only for testing purposes
    internal init(out: Pipe? = nil, error: Pipe? = nil) {
        self.out = out
        self.error = error
    }

    public func run(task: CommandTask) throws {
        for command in task.commands {
            let process = newProcess(command: command)
            process.launch()
            process.waitUntilExit()

            if process.terminationStatus != 0 {
                throw NoonianKitError.taskFailed(taskName: task.name, command: command)
            }
        }
    }

    private func newProcess(command: String) -> Process {
        let process = Process()

        process.standardOutput = out ?? pipe() { print($0, terminator: "") }
        process.standardError = error ?? pipe() { print($0, terminator: "") }
        process.launchPath = "/bin/sh"

        process.arguments = [
            "-c",
            command
        ]

        return process
    }

    private func pipe(printer: ((String) -> Void)?) -> Pipe {
        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = {
            handle in
            if let contents = String(data: handle.availableData, encoding: .utf8) {
                printer?(contents)
            }
        }
        return pipe
    }
}
