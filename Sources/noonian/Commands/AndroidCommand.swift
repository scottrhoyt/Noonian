//
//  AndroidCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import NoonianKit

protocol AndroidCommand: CommandProtocol { }

extension AndroidCommand {
    private var android: String {
        return "tools/android"
    }

    func androidHome() throws -> String {
        guard let androidHome = Environment().stringValue(for: EnvironmentKeys.androidHome.rawValue) else {
            throw NoonianError.androidHomeNotDefined
        }
        return androidHome
    }

    func androidCommand() throws -> String {
        return (try androidHome()).pathByAdding(component: android)
    }
}
