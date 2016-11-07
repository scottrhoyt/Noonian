//
//  main.swift
//  noonian
//
//  Created by Scott Hoyt on 10/31/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import NoonianKit

// TODO: Need to create a Makefile

// Create registry and add commands
let registry = CommandRegistry<NoonianError>()
registry.register(InitCommand())
registry.register(BuildCommand())
registry.register(PackageCommand())
registry.register(InstallCommand())

// Add help command
let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb, errorHandler: {
    error in
    print("ERROR: " + error.description)
})
