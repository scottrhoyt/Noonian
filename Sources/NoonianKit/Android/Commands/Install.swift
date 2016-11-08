//
//  Install.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct Install: AndroidCommand {
    public typealias Options = NoOptions<NoonianKitError>

    public let verb = "install"
    public let function = "Install the app on a running simulator."

    public init() { }

    func run(_ options: NoOptions<NoonianKitError>, paths: SDKPathBuilder) throws {
        let configuration = try NoonianConfiguration()

        try execute(
            commands: [
                install(adbTool: paths.adbToolCommand(), appName: configuration.appName()),
            ],
            configuration: configuration
        )
    }

    func install(adbTool: String, appName: String) -> ShellCommand {
        let arguments = [
            ShellArgument("install"),
            ShellArgument("-r"),
            ShellArgument("bin/\(appName).apk"),
        ]

        return ShellCommand(command: adbTool, arguments: arguments)
    }
}
