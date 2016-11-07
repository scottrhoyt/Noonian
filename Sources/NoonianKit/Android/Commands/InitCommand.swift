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

        // TODO: Need to add better shell printing of what we are doing here.
        let commands = [
            projectCreation(androidTool: androidTool, options: options),
            copyingExampleConfig(projectPath: options.path),
            addingTargetToConfig(target: options.target, projectPath: options.path)
        ]

        let task = CommandTask(name: verb, commands: commands)

        let runner = Runner()
        runner.run(task: task)
    }

    func projectCreation(androidTool: String, options: InitOptions) -> ShellCommand {
        let arguments = [
            ShellArgument("create", "project"),
            ShellArgument("-a", options.activity),
            ShellArgument("-p", options.path),
            ShellArgument("-t", options.target),
            ShellArgument("-k", options.package),
            ShellArgument("-n", options.projectName),
        ]

        return ShellCommand(command: androidTool, arguments: arguments)
    }

    func copyingExampleConfig(projectPath: String) -> ShellCommand {
        let arguments = [
            // TODO: might want to extract install location to somewhere more reasonable
            ShellArgument("/usr/local/lib/noonian/example.noonian.yml"),
            ShellArgument(projectPath.pathByAdding(component: ".noonian.yml")),
        ]

        return ShellCommand(command: "cp", arguments: arguments)
    }

    func addingTargetToConfig(target: String, projectPath: String) -> ShellCommand {
        let arguments = [
            ShellArgument("target: \(target)", ">>", projectPath.pathByAdding(component: NoonianConfiguration.defaultFileName))
        ]

        return ShellCommand(command: "echo", arguments: arguments)
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
