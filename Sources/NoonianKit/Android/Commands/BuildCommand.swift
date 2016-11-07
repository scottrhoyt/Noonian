//
//  BuildCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct BuildCommand: AndroidCommand {
    public typealias Options = BuildOptions

    public let verb = "build"
    public let function = "Build, package, and sign the app."

    public init() { }

    func run(_ options: BuildOptions) throws {
        let configuration = try NoonianConfiguration()
        let toolsVersion = configuration.buildTools()
        let buildTools = try buildToolsPath(toolsVersion: toolsVersion)
        let target: String = try configuration.target()

        try execute(
            commands: [
                packagingResources(buildTools: buildTools, target: target),
                compiling(buildTools: buildTools, target: target)
            ],
            configuration: configuration
        )
    }

    // TODO: Consider passing in configuration instead. This would make it better when splitting the commands.
    func packagingResources(buildTools: String, target: String) throws -> ShellCommand {
        let command = packageToolPath(buildTools: buildTools)
        let arguments = [
            ShellArgument("package"),
            ShellArgument("-v"),
            ShellArgument("-f"),
            ShellArgument("-m"),
            ShellArgument("-S", "res"),
            ShellArgument("-J", "src"),
            ShellArgument("-M", "AndroidManifest.xml"),
            ShellArgument("-I", try includeFor(target: target)),
        ]

        return ShellCommand(command: command, arguments: arguments)
    }

    func compiling(buildTools: String, target: String) throws -> ShellCommand {
        let command = jackToolCommand(buildTools: buildTools)
        let arguments = [
            ShellArgument("--verbose", "info"),
            ShellArgument("-cp", try includeFor(target: target)),
            ShellArgument("--output-dex", "bin"),
            ShellArgument("src"),
        ]

        return ShellCommand(command: command, arguments: arguments)
    }
}

public struct BuildOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return .success(BuildOptions())
    }
}
