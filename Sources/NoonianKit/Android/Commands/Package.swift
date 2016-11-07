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

    func run(_ options: PackageOptions, paths: SDKPathBuilder) throws {
        let configuration = try NoonianConfiguration()
        let toolsVersion = configuration.buildTools()
        let target = try configuration.target()

        try execute(
            commands: [
                packagingApk(
                    packageTool: paths.packageToolPath(toolsVersion: toolsVersion),
                    include: paths.includeFor(target: target)
                ),
                signingApk(),
                zipAlign(zipTool: paths.zipAlignToolCommand(toolsVersion: toolsVersion)),
            ],
            configuration: configuration
        )
    }

    func packagingApk(packageTool: String, include: String) -> ShellCommand {
        let arguments = [
            ShellArgument("package"),
            ShellArgument("-v"),
            ShellArgument("-f"),
            ShellArgument("-M", "AndroidManifest.xml"),
            ShellArgument("-S", "res"),
            ShellArgument("-I", include),
            ShellArgument("-F", "bin/\(appName).unsigned.apk"),
            ShellArgument("bin")
        ]

        return ShellCommand(command: packageTool, arguments: arguments)
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

    func zipAlign(zipTool: String) -> ShellCommand {
        let arguments = [
            ShellArgument("-v"),
            ShellArgument("-f", "4"),
            ShellArgument("bin/\(appName).signed.apk"),
            ShellArgument("bin/\(appName).apk"),
        ]

        return ShellCommand(command: zipTool, arguments: arguments)
    }
}

public struct PackageOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<PackageOptions, CommandantError<NoonianError>> {
        return .success(PackageOptions())
    }
}
