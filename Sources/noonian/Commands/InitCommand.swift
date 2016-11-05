//
//  InitCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result
import NoonianKit

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Initialize a new Android project"

    func run(_ options: InitOptions) -> Result<(), NoonianError> {
        print("I still don't do anything")
        return .success()
    }
}

struct InitOptions: OptionsProtocol {
    let androidHome: String?
    let path: String
    let projectName: String

    static func create(_ androidHome: String?) -> (_ path: String) -> (_ projectName: String) -> InitOptions {
        return { path in { projectName in {
                    return self.init(androidHome: androidHome, path: path, projectName: projectName)
                }() } }
    }

    static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return create
            <*> m <| androidHomeOption
            <*> m <| Option(
                                key: "path",
                                defaultValue: FileManager.default.currentDirectoryPath,
                                usage: "The directory to create the project in. Defaults to the current directory."
                    )
            <*> m <| Argument(usage: "the project name")
    }
}
