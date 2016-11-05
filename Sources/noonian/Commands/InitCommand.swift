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

struct InitCommand: AndroidCommand {
    let verb = "init"
    let function = "Initialize a new Android project"

    func run(_ options: InitOptions) -> Result<(), NoonianError> {
        let command = getAndroidCommand(androidHome: options.androidHome)

        let verbArg = Arguement(flag: "create", value: "project")
        let activityArg = Arguement(flag: "-a", value: "Main")
        let pathArg = Arguement(flag: "-p", value: options.path)
        let targetArg = Arguement(flag: "-t", value: options.target)
        let packageArg = Arguement(flag: "-k", value: options.package)
        let projectArg = Arguement(flag: "-n", value: options.projectName)
        let args = [verbArg, activityArg, pathArg, targetArg, packageArg, projectArg]

        let task = CommandTask(name: "init", commandsWithArgs: [CommandArgumentsPair(command: command, arguments: args)])
        let runner = Runner()
        runner.run(task: task)
        print("I still don't do anything")
        print(options)
        return .success()
    }
}

struct InitOptions: OptionsProtocol {
    let androidHome: String?
    let path: String
    let activity: String
    let target: String
    let package: String
    let projectName: String

    static func create(_ androidHome: String?)
        -> (_ path: String?)
        -> (_ activity: String)
        -> (_ target: String)
        -> (_ package: String?)
        -> (_ projectName: String)
        -> InitOptions {
            return { path in { activity in { target in { package in { projectName in {
                // TODO create a string extension to add paths together
                let correctedPath = path ?? FileManager.default.currentDirectoryPath + "/" + projectName
                let packageName = package ?? "com.example." + projectName
                return self.init(
                    androidHome: androidHome,
                    path: correctedPath,
                    activity: activity,
                    target: target,
                    package: packageName,
                    projectName: projectName
                )
            }() } }}}}
    }

    // TODO: Rewrite with Curry (create function that takes the optionals and converts them)
    static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return create
            <*> m <| androidHomeOption
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
                                defaultValue: "18",
                                usage: "The target to build for. Defaults to Android 7.0."
                    )
            <*> m <| Option<String?>(
                                key: "package",
                                defaultValue: nil,
                                usage: "The package name. Defaults to com.example.<project>."
                    )
            <*> m <| Argument(usage: "the project name")
    }
}
