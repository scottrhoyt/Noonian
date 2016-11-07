//
//  Package.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct Package: AndroidCommand {
    public typealias Options = PackageOptions

    public let verb = "package"
    public let function = "Sign and package an app."

    public init() { }

    func run(_ options: PackageOptions, androidHome: String) throws {
        let configuration = try NoonianConfiguration()
        let buildTools = try buildToolsPath(toolsVersion: configuration.buildTools())
        let target = try configuration.target()

        try execute(
            commands: [
                packagingApk(buildTools: buildTools, target: target),
                signingApk(),
                zipAlign(buildTools: buildTools),
            ],
            configuration: configuration
        )
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

    func signingApk() -> ShellCommand {
        let command = "jarsigner"
        let arguments = [
            ShellArgument("-verbose"),
            ShellArgument("-keystore", "~/.android/debug.keystore"),
            ShellArgument("-storepass", "android"),
            ShellArgument("-keypass", "android"),
            ShellArgument("-signedjar", "bin/\(appName).signed.apk"),
            ShellArgument("bin/\(appName).unsigned.apk"),
            ShellArgument("androiddebugkey"),
        ]

        return ShellCommand(command: command, arguments: arguments)
    }

    func zipAlign(buildTools: String) -> ShellCommand {
        let command = zipAlignToolCommand(buildTools: buildTools)
        let arguments = [
            ShellArgument("-v"),
            ShellArgument("-f", "4"),
            ShellArgument("bin/\(appName).signed.apk"),
            ShellArgument("bin/\(appName).apk"),
        ]

        return ShellCommand(command: command, arguments: arguments)
    }
}

public struct PackageOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<PackageOptions, CommandantError<NoonianError>> {
        return .success(PackageOptions())
    }
}
