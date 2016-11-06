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

        let verbArg = CommandArgument(flag: "create", value: "project")
        let activityArg = CommandArgument(flag: "-a", value: "Main")
        let pathArg = CommandArgument(flag: "-p", value: options.path)
        let targetArg = CommandArgument(flag: "-t", value: options.target)
        let packageArg = CommandArgument(flag: "-k", value: options.package)
        let projectArg = CommandArgument(flag: "-n", value: options.projectName)
        let args = [verbArg, activityArg, pathArg, targetArg, packageArg, projectArg]

        let task = CommandTask(name: "init", commands: [Command(command: command, arguments: args)])
        let runner = Runner()
        runner.run(task: task)

        // TODO: Need to copy example configuration
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
