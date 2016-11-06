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
        print(assemble(command: packageCommand))
        print(assemble(command: compileCommand))

        let runner = Runner()
        runner.run(task: task)
    }

    private func commandToPackageResources(buildTools: String, target: String) throws -> ShellCommand {
        // TODO: Rename these arguements
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument(flag: "package", value: nil))
        arguments.append(ShellArgument(flag: "-v", value: nil))
        arguments.append(ShellArgument(flag: "-f", value: nil))
        arguments.append(ShellArgument(flag: "-m", value: nil))
        arguments.append(ShellArgument(flag: "-S", value: "res"))
        arguments.append(ShellArgument(flag: "-J", value: "src"))
        arguments.append(ShellArgument(flag: "-M", value: "AndroidManifest.xml"))
        arguments.append(ShellArgument(flag: "-I", value: try includeFor(target: target)))

        return ShellCommand(command: packageToolPath(buildTools: buildTools), arguments: arguments)
    }

    private func commandToCompile(buildTools: String, target: String) throws -> ShellCommand {
        var arguments = [ShellArgument]()

        arguments.append(ShellArgument(flag: "--verbose", value: "info"))
        arguments.append(ShellArgument(flag: "-cp", value: try includeFor(target: target)))
        arguments.append(ShellArgument(flag: "--output-dex", value: "bin"))
        arguments.append(ShellArgument(flag: "src", value: nil))

        return ShellCommand(command: jackToolCommand(buildTools: buildTools), arguments: arguments)
    }
}

struct BuildOptions: OptionsProtocol {
    static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return .success(BuildOptions())
    }
}
