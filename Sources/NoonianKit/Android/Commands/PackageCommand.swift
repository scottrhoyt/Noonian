//
//  PackageCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct PackageCommand: AndroidCommand {
    public typealias Options = PackageOptions

    public let verb = "package"
    public let function = "Sign and package an app."

    public init() { }

    func run(_ options: PackageOptions) throws {
        //
    }

    func packagingApk(buildTools: String, target: String) throws -> ShellCommand {
        let command = packageToolPath(buildTools: buildTools)
        let arguments = [
            ShellArgument("package"),
            ShellArgument("-v"),
            ShellArgument("-f"),
            ShellArgument("-M", "AndroidManifest.xml"),
            ShellArgument("-S", "res"),
            ShellArgument("-I", try includeFor(target: target)),
            ShellArgument("-F", "bin/\(appName).unsigned.apk"),
            ShellArgument("bin")
        ]

        return ShellCommand(command: command, arguments: arguments)
    }
}

public struct PackageOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<PackageOptions, CommandantError<NoonianError>> {
        return .success(PackageOptions())
    }
}
