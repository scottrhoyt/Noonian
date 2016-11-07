//
//  AndroidCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

protocol AndroidCommand: CommandProtocol {
    typealias ClientError = NoonianError

    func run(_ options: Self.Options, paths: SDKPathBuilder) throws
}

extension AndroidCommand {
    func androidHome() throws -> String {
        guard let androidHome = Environment().stringValue(for: EnvironmentKeys.androidHome.rawValue) else {
            throw NoonianError.androidHomeNotDefined
        }
        return androidHome
    }

    public func run(_ options: Self.Options) -> Result<(), NoonianError> {
        do {
            try run(options, paths: SDKPathBuilder(androidHome: androidHome()))
            return .success()
        } catch {
            return .failure((error as? NoonianError) ?? .internalError(error))
        }
    }

    func execute(task: CommandTask) throws {
        let runner = Runner()
        try runner.run(task: task)
    }
    
    func execute(commands: [ShellCommand]) throws {
        let task = CommandTask(name: verb, commands: commands)
        try execute(task: task)
    }

    func execute(commands: [ShellCommand], configuration: NoonianConfiguration) throws {
        let beforeTaskKey = "before_" + verb
        let afterTaskKey = "after_" + verb

        // TODO: Maybe put these in configuration
        let beforeTask = try? CommandTask(name: beforeTaskKey, configuration: configuration.value(for: beforeTaskKey))
        let afterTask = try? CommandTask(name: afterTaskKey, configuration: configuration.value(for: afterTaskKey))

        try [beforeTask, CommandTask(name: verb, commands: commands), afterTask].flatMap { $0 }.forEach(execute)
    }
}
