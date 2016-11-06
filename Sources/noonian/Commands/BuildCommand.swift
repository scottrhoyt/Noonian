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
import NoonianKit
import Curry

struct BuildCommand: AndroidCommand {
    typealias Options = BuildOptions

    let verb = "build"
    let function = "Build, package, and sign the app."

    func run(_ options: BuildOptions) throws {
        let buildTools = try buildToolsPath()

        // TODO: Need to derive the target from the configuration file
        let target = "android-25"
        let packageCommand = try commandToPackageResources(buildTools: buildTools, target: target)
        let compileCommand = try commandToCompile(buildTools: buildTools, target: target)

        let task = CommandTask(name: "build", commands: [packageCommand, compileCommand])

        let runner = Runner()
        runner.run(task: task)
    }

    private func commandToPackageResources(buildTools: String, target: String) throws -> ShellCommand {
        // TODO: Rename these arguements
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument("package"))
        arguments.append(ShellArgument("-v"))
        arguments.append(ShellArgument("-f"))
        arguments.append(ShellArgument("-m"))
        arguments.append(ShellArgument("-S", "res"))
        arguments.append(ShellArgument("-J", "src"))
        arguments.append(ShellArgument("-M", "AndroidManifest.xml"))
        arguments.append(ShellArgument("-I", try includeFor(target: target)))

        return ShellCommand(command: packageToolPath(buildTools: buildTools), arguments: arguments)
    }

    private func commandToCompile(buildTools: String, target: String) throws -> ShellCommand {
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument("--verbose", "info"))
        arguments.append(ShellArgument("-cp", try includeFor(target: target)))
        arguments.append(ShellArgument("--output-dex", "bin"))
        arguments.append(ShellArgument("src"))

        return ShellCommand(command: jackToolCommand(buildTools: buildTools), arguments: arguments)
    }
}

struct BuildOptions: OptionsProtocol {
    static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return .success(BuildOptions())
    }
}
