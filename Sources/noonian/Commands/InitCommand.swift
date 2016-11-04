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

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Initialize a new Android project"

    func run(_ options: InitOptions) -> Result<(), NoonianError> {
        print("I still don't do anything")
        return .success()
    }
}

struct InitOptions: OptionsProtocol {
    static func evaluate(_ m: CommandMode) -> Result<InitOptions, CommandantError<NoonianError>> {
        return .success(InitOptions())
    }
}
