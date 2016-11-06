//
//  AndroidCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result
import NoonianKit

protocol AndroidCommand: CommandProtocol {
    associatedtype _Options
    typealias ClientError = NoonianError
    typealias Options = _Options

    func run(_ options: _Options) throws
}

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

    func run(_ options: _Options) -> Result<(), NoonianError> {
        do {
            try run(options)
            return .success()
        } catch {
            return .failure((error as? NoonianError) ?? .unknown(error))
        }
    }
}
