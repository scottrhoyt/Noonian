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
        let command = try androidCommand()
        //let task = commandTask(options: options, command: command)

        //let runner = Runner()
        //runner.run(task: task)
    }
}

struct BuildOptions: OptionsProtocol {
    let path: String
    let activity: String
    let target: String
    let package: String
    let projectName: String

    init(path: String?, activity: String, target: String, package: String?, projectName: String) {
        let fullPath = path ?? FileManager.default.currentDirectoryPath.pathByAdding(component: projectName)
        let packageName = package ?? "com.example." + projectName

        self.path = fullPath
        self.activity = activity
        self.target = target
        self.package = packageName
        self.projectName = projectName
    }

    static func evaluate(_ m: CommandMode) -> Result<BuildOptions, CommandantError<NoonianError>> {
        return curry(BuildOptions.init)
            <*> m <| Option(
                                key: "path",
                                defaultValue: nil,
                                usage: "The directory to create the project in. Defaults to <Project Name> in the current directory."
                     )
            <*> m <| Option(
                                key: "activity",
                                defaultValue: "Main",
                                usage: "The name of the activity. Defaults to Main."
                     )
            <*> m <| Option(
                                key: "target",
                                defaultValue: "android-25",
                                usage: "The target to build for. Specify by target name and not ID. Defaults to android-25 (7.1)."
                     )
            <*> m <| Option<String?>(
                                key: "package",
                                defaultValue: nil,
                                usage: "The package name. Defaults to com.example.<project>."
                     )
            <*> m <| Argument(usage: "the project name")
    }
}
