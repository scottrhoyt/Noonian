//
//  InitCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result
import NoonianKit
import Curry

struct InitCommand: AndroidCommand {
    typealias Options = InitOptions // TODO: Hopefully we can find a way to infer this

    let verb = "init"
    let function = "Initialize a new Android project"

    func run(_ options: InitOptions) throws {
        let command = try androidCommand()
        let task = commandTask(options: options, command: command)

        let runner = Runner()
        runner.run(task: task)

        // TODO: Need to copy example configuration
    }

    private func commandTask(options: InitOptions, command: String) -> CommandTask {
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument(flag: "create", value: "project"))
        arguments.append(ShellArgument(flag: "-a", value: "Main"))
        arguments.append(ShellArgument(flag: "-p", value: options.path))
        arguments.append(ShellArgument(flag: "-t", value: options.target))
        arguments.append(ShellArgument(flag: "-k", value: options.package))
        arguments.append(ShellArgument(flag: "-n", value: options.projectName))

        let task = CommandTask(name: "init", commands: [ShellCommand(command: command, arguments: arguments)])
        return task
    }
}

struct InitOptions: OptionsProtocol {
    let path: String
    let activity: String
    let target: String
    let package: String
    let projectName: String

    init(path: String?, activity: String, target: String, package: String?, projectName: String) {
        self.path = path ?? projectName
        self.activity = activity
        self.target = target
        self.package = package ?? "com.example." + projectName
        self.projectName = projectName
    }

    static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return curry(InitOptions.init)
            <*> m <| Option(
                                key: "path",
                                defaultValue: nil,
                                usage: "The directory to create the project in. Defaults to <Project Name> in the current directory."
                     )
            <*> m <| Option(
                                key: "activity",
                                defaultValue: "Main",
                                usage: "The name of the activity. Defaults to Main."
                     )
            <*> m <| Option(
                                key: "target",
                                defaultValue: "android-25",
                                usage: "The target to build for. Specify by target name and not ID. Defaults to android-25 (7.1)."
                     )
            <*> m <| Option<String?>(
                                key: "package",
                                defaultValue: nil,
                                usage: "The package name. Defaults to com.example.<project>."
                     )
            <*> m <| Argument(usage: "the project name")
    }
}
