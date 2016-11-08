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
    public typealias Options = NoOptions<NoonianKitError>

    public let verb = "package"
    public let function = "Package, sign, and zipalign an app."

    public init() { }

    func run(_ options: NoOptions<NoonianKitError>, paths: SDKPathBuilder) throws {
        let configuration = try NoonianConfiguration()
        let toolsVersion = configuration.buildTools()
        let target = try configuration.target()
        let appName = configuration.appName()

        try execute(
            commands: [
                removeApks(),  // Need to do this to prevent aapt from entering an endless loop
                packagingApk(
                    packageTool: paths.packageToolCommand(toolsVersion: toolsVersion),
                    include: paths.includeFor(target: target),
                    appName: appName
                ),
                signingApk(appName: appName),
                zipAlign(zipTool: paths.zipAlignToolCommand(toolsVersion: toolsVersion), appName: appName),
            ],
            configuration: configuration
        )
    }

    func removeApks() -> ShellCommand {
        let arguments = [
            ShellArgument("-f"),
            ShellArgument("bin/*.apk")
        ]

        return ShellCommand(command: "rm", arguments: arguments)
    }

    func packagingApk(packageTool: String, include: String, appName: String) -> ShellCommand {
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

    func signingApk(appName: String) -> ShellCommand {
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

    func zipAlign(zipTool: String, appName: String) -> ShellCommand {
        let arguments = [
            ShellArgument("-v"),
            ShellArgument("-f", "4"),
            ShellArgument("bin/\(appName).signed.apk"),
            ShellArgument("bin/\(appName).apk"),
        ]

        return ShellCommand(command: zipTool, arguments: arguments)
    }
}
