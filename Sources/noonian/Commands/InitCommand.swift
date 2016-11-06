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
        let verbArg = ShellArgument(flag: "create", value: "project")
        let activityArg = ShellArgument(flag: "-a", value: "Main")
        let pathArg = ShellArgument(flag: "-p", value: options.path)
        let targetArg = ShellArgument(flag: "-t", value: options.target)
        let packageArg = ShellArgument(flag: "-k", value: options.package)
        let projectArg = ShellArgument(flag: "-n", value: options.projectName)
        let args = [verbArg, activityArg, pathArg, targetArg, packageArg, projectArg]

        let task = CommandTask(name: "init", commands: [ShellCommand(command: command, arguments: args)])
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
        let fullPath = path ?? FileManager.default.currentDirectoryPath.pathByAdding(component: projectName)
        let packageName = package ?? "com.example." + projectName

        self.path = fullPath
        self.activity = activity
        self.target = target
        self.package = packageName
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
