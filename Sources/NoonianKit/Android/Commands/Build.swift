//
//  Build.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct Build: AndroidCommand {
    public typealias Options = NoOptions<NoonianKitError>

    public let verb = "build"
    public let function = "Compile an app."

    public init() { }

    func run(_ options: NoOptions<NoonianKitError>, paths: SDKPathBuilder) throws {
        let configuration = try NoonianConfiguration()
        let toolsVersion = configuration.buildTools()
        let target: String = try configuration.target()

        try execute(
            commands: [
                packagingResources(
                    packageTool: paths.packageToolCommand(toolsVersion: toolsVersion),
                    include: paths.includeFor(target: target)
                ),
                compiling(
                    jackTool: paths.jackToolCommand(toolsVersion: toolsVersion),
                    include: paths.includeFor(target: target)
                )
            ],
            configuration: configuration
        )
    }

    func packagingResources(packageTool: String, include: String) -> ShellCommand {
        let arguments = [
            ShellArgument("package"),
            ShellArgument("-v"),
            ShellArgument("-f"),
            ShellArgument("-m"),
            ShellArgument("-S", "res"),
            ShellArgument("-J", "src"),
            ShellArgument("-M", "AndroidManifest.xml"),
            ShellArgument("-I", include),
        ]

        return ShellCommand(command: packageTool, arguments: arguments)
    }

    func compiling(jackTool: String, include: String) -> ShellCommand {
        let arguments = [
            ShellArgument("--verbose", "info"),
            ShellArgument("-cp", include),
            ShellArgument("--output-dex", "bin"),
            ShellArgument("src"),
        ]

        return ShellCommand(command: jackTool, arguments: arguments)
    }
}
