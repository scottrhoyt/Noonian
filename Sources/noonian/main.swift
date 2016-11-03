//
//  main.swift
//  noonian
//
//  Created by Scott Hoyt on 10/31/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

enum NoonianError: Error { }

struct InitCommand: CommandProtocol {
    let verb = "init"
    let function = "Initialize a new Android project."

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

let registry = CommandRegistry<NoonianError>()
registry.register(InitCommand())
registry.register(HelpCommand(registry: registry))

registry.main(defaultVerb: InitCommand().verb, errorHandler: {
    error in
    print(error)
})
