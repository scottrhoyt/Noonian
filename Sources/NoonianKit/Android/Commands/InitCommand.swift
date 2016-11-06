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
import Curry

public struct InitCommand: AndroidCommand {
    public typealias Options = InitOptions // TODO: Hopefully we can find a way to infer this

    public let verb = "init"
    public let function = "Initialize a new Android project"

    public init() { }

    func run(_ options: InitOptions) throws {
        let androidTool = try androidToolPath()
        let creationCommand = commandForProjectCreation(androidTool: androidTool, options: options)

        let task = CommandTask(name: "init", commands: [creationCommand])

        let runner = Runner()
        runner.run(task: task)

        // TODO: Need to copy example configuration
    }

    func commandForProjectCreation(androidTool: String, options: InitOptions) -> ShellCommand {
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument("create", "project"))
        arguments.append(ShellArgument("-a", options.activity))
        arguments.append(ShellArgument("-p", options.path))
        arguments.append(ShellArgument("-t", options.target))
        arguments.append(ShellArgument("-k", options.package))
        arguments.append(ShellArgument("-n", options.projectName))

        return ShellCommand(command: androidTool, arguments: arguments)
    }
}

public struct InitOptions: OptionsProtocol {
    let path: String
    let activity: String
    let target: String
    let package: String
    let projectName: String

    init(path: String?, activity: String?, target: String?, package: String?, projectName: String) {
        self.path = path ?? projectName
        self.activity = activity ?? "Main"
        self.target = target ?? "android-25"
        self.package = package ?? "com.example." + projectName
        self.projectName = projectName
    }

    public static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return curry(InitOptions.init)
            <*> m <| Option(
                                key: "path",
                                defaultValue: nil,
                                usage: "The directory to create the project in. Defaults to <Project Name> in the current directory."
                     )
            <*> m <| Option<String?>(
                                key: "activity",
                                defaultValue: nil,
                                usage: "The name of the activity. Defaults to Main."
                     )
            <*> m <| Option<String?>(
                                key: "target",
                                defaultValue: nil,
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
