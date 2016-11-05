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
    private weak var externalOut: Pipe? = nil
    private weak var externalError: Pipe? = nil

    public init() {
        self.init(out: nil, error: nil)
    }

    // This is only for testing purposes
    internal init(out: Pipe? = nil, error: Pipe? = nil) {
        self.externalOut = out
        self.externalError = error
    }

    public func run(task: CommandTask) throws {
        for command in task.commands {
            let process = newProcess(command: command)
            let (internalOut, internalError) = setPipes(process: process)
            process.launch()

            if let out = internalOut { handlePipe(pipe: out) { print($0, terminator: "") } }
            if let error = internalError { handlePipe(pipe: error) { print($0, terminator: "") } }

            process.waitUntilExit()

            if process.terminationStatus != 0 {
                throw NoonianKitError.taskFailed(taskName: task.name, command: command)
            }
        }
    }

    private func newProcess(command: String) -> Process {
        let process = Process()
        process.launchPath = "/bin/sh"

        process.arguments = [
            "-c",
            command
        ]

        return process
    }

    // Sets the pipes for the process. Returns internal pipes if needed.
    private func setPipes(process: Process) -> (out: Pipe?, error: Pipe?) {
        let internalOut = Pipe()
        let internalError = Pipe()
        process.standardOutput = externalOut ?? internalOut
        process.standardError = externalError ?? internalError
        return (
            out: externalOut == nil ? internalOut : nil,
            error: externalError == nil ? internalError : nil
        )
    }

    private func handlePipe(pipe: Pipe, printer: ((String) -> Void)?) {
        // OS X has libdispatch which allows us to read the output asynchronously.
        // Since libdispatch is not included in Swift for linux as of yet, we have
        // to read synchronously.
        #if !os(Linux)
            pipe.fileHandleForReading.readabilityHandler = {
                handle in
                if let contents = String(data: handle.availableData, encoding: .utf8) {
                    printer?(contents)
                }
            }
        #else
            let outData = pipe.fileHandleForReading.readDataToEndOfFile()
            if let contents = String(data: outData, encoding: .utf8) {
                printer?(contents)
            }
        #endif
    }
}
