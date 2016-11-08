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
    typealias ClientError = NoonianKitError

    func run(_ options: Self.Options, paths: SDKPathBuilder) throws
}

extension AndroidCommand {
    func androidHome() throws -> String {
        guard let androidHome = Environment().stringValue(for: EnvironmentKeys.androidHome.rawValue) else {
            throw NoonianKitError.androidHomeNotDefined
        }
        return androidHome
    }

    public func run(_ options: Self.Options) -> Result<(), NoonianKitError> {
        do {
            try run(options, paths: SDKPathBuilder(androidHome: androidHome()))
            return .success()
        } catch {
            return .failure((error as? NoonianKitError) ?? .internalError(error))
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
        let tasks: [CommandTask?] = [
            try? configuration.configuredValue(for: ConfigurationKeys.beforeTask.rawValue + verb),
            CommandTask(name: verb, commands: commands),
            try? configuration.configuredValue(for: ConfigurationKeys.afterTask.rawValue + verb),
        ]

        try tasks.flatMap { $0 }.forEach(execute)
    }
}
