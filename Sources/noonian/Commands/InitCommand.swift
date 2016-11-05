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

    func run(_ options: InitOptions) -> Result<(), NoonianError> {
        let command = getAndroidCommand(androidHome: options.androidHome)

        let verbArg = Arguement(flag: "create", value: "project")
        let activityArg = Arguement(flag: "-a", value: "Main")
        let pathArg = Arguement(flag: "-p", value: options.path)
        let targetArg = Arguement(flag: "-t", value: options.target)
        let packageArg = Arguement(flag: "-k", value: options.package)
        let projectArg = Arguement(flag: "-n", value: options.projectName)
        let args = [verbArg, activityArg, pathArg, targetArg, packageArg, projectArg]

        let task = CommandTask(name: "init", commandsWithArgs: [CommandWithArguments(command: command, arguments: args)])
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

    init(androidHome: String?, path: String?, activity: String, target: String, package: String?, projectName: String) {
        let fullPath = path ?? FileManager.default.currentDirectoryPath.pathByAdding(component: projectName)
        let packageName = package ?? "com.example." + projectName

        self.androidHome = androidHome
        self.path = fullPath
        self.activity = activity
        self.target = target
        self.package = packageName
        self.projectName = projectName
    }

    static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return curry(InitOptions.init)
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
