//
//  NoonianError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/5/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

protocol HasDescription {
    var description: String { get }
}

extension NSError: HasDescription { }

public enum NoonianError: Error {
    case internalError(Error)
    case androidHomeNotDefined
    case noBuildTools
    case missingConfiguration(key: String)
    case cannotReadConfiguration(key: String, type: String)

    public var description: String {
        switch self {
        case .internalError(let error):
            return description(from: error)
        case .androidHomeNotDefined:
            return "\(EnvironmentKeys.androidHome.rawValue) is not defined"
        case .noBuildTools:
            return "Your SDK does not have any build tools."
        case .missingConfiguration(let config):
            return "Your configuration file is missing an entry for: \(config)"
        case .cannotReadConfiguration(let key, let type):
            return "Cannot read configuration for: \(key). Expected type: \(type)"
        }
    }

    private func description(from error: Error) -> String {
        if let error = error as? HasDescription {
            return error.description
        } else {
            return "An unknown error has occurred: \(error)"
        }
    }
}
