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

// Create registry and add commands
let registry = CommandRegistry<NoonianKitError>()
registry.register(Init())
registry.register(Build())
registry.register(Package())
registry.register(Install())
registry.register(All())

// Add help command
let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb, errorHandler: {
    error in
    log.error(error.explanation)
})
