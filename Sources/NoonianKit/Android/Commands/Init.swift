//
//  Init.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result
import Curry

public struct Init: AndroidCommand {
    public typealias Options = InitOptions

    public let verb = "init"
    public let function = "Initialize a new Android project."

    public init() { }

    func run(_ options: InitOptions, paths: SDKPathBuilder) throws {
        try execute(
            commands: [
                projectCreation(options: options, androidTool: paths.androidToolCommand()),
                copyingExampleConfig(projectPath: options.path),
                addingStringToConfig(contents: "\(ConfigurationKeys.target.rawValue): \(options.target)", projectPath: options.path),
                addingStringToConfig(contents: "\(ConfigurationKeys.appName.rawValue): \(options.projectName)", projectPath: options.path)
            ]
        )
    }

    func projectCreation(options: InitOptions, androidTool: String) -> ShellCommand {
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
        let command = "cp"
        let arguments = [
            ShellArgument(NoonianConfiguration.examplePath),
            ShellArgument(projectPath.pathByAdding(component: NoonianConfiguration.defaultFileName)),
        ]

        return ShellCommand(command: command, arguments: arguments)
    }

    func addingStringToConfig(contents: String, projectPath: String) -> ShellCommand {
        let command = "echo"
        let arguments = [
            ShellArgument(contents, ">>", projectPath.pathByAdding(component: NoonianConfiguration.defaultFileName))
        ]

        return ShellCommand(command: command, arguments: arguments)
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

    public static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianKitError>> {
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
