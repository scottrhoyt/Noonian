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
import Curry

public struct BuildCommand: AndroidCommand {
    public typealias Options = BuildOptions

    public let verb = "build"
    public let function = "Build, package, and sign the app."

    public init() { }

    func run(_ options: BuildOptions) throws {
        let configuration = try NoonianConfiguration()
        let toolsVersion = configuration.buildTools()
        if toolsVersion == nil { print("Tools Version not supplied. Using latest.") }
        let buildTools = try buildToolsPath(toolsVersion: toolsVersion)

        // TODO: Need to move this constant somewhere else
        let target: String = try configuration.value(for: "target")

        let commands = [
            try packagingResources(buildTools: buildTools, target: target),
            try compiling(buildTools: buildTools, target: target)
        ]

        run(commands: commands)
    }

    func packagingResources(buildTools: String, target: String) throws -> ShellCommand {
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

        return ShellCommand(command: packageToolPath(buildTools: buildTools), arguments: arguments)
    }

    func compiling(buildTools: String, target: String) throws -> ShellCommand {
        let arguments = [
            ShellArgument("--verbose", "info"),
            ShellArgument("-cp", try includeFor(target: target)),
            ShellArgument("--output-dex", "bin"),
            ShellArgument("src"),
        ]

        return ShellCommand(command: jackToolCommand(buildTools: buildTools), arguments: arguments)
    }
}

public struct BuildOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return .success(BuildOptions())
    }
}
