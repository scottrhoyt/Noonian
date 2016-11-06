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
    let verb = "build"
    let function = "Build, package, and sign the app."

    func run(_ options: BuildOptions) throws {
        let buildTools = try buildToolsPath()

        // TODO: Need to derive the target from the configuration file
        let target = "android-25"
        let command = try commandToPackageResources(buildTools: buildTools, target: target)

        let task = CommandTask(name: "build", commands: [command])
        print(assemble(command: command))

        let runner = Runner()
        runner.run(task: task)
    }

    private func commandToPackageResources(buildTools: String, target: String) throws -> ShellCommand {
        // TODO: Rename these arguements
        let arg0 = ShellArgument(flag: "package", value: nil)
        let arg1 = ShellArgument(flag: "-v", value: nil)
        let arg2 = ShellArgument(flag: "-f", value: nil)
        let arg3 = ShellArgument(flag: "-m", value: nil)
        let arg4 = ShellArgument(flag: "-S", value: "res")
        let arg5 = ShellArgument(flag: "-J", value: "src")
        let arg6 = ShellArgument(flag: "-M", value: "AndroidManifest.xml")
        let arg7 = ShellArgument(flag: "-I", value: try includeFor(target: target))
        return ShellCommand(command: packageToolPath(buildTools: buildTools), arguments: [arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7])
    }
}

struct BuildOptions: OptionsProtocol {
    static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return .success(BuildOptions())
    }
}
