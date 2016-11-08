//
//  UtilityError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public protocol HasExplanation {
    var explanation: String { get }
}

extension NSError: HasExplanation {
    public var explanation: String {
        return localizedDescription
    }
}

public enum UtilityError: HasExplanation, Error {
    case taskFailed(taskName: String, command: String)
    case configurationParsing
    case cannotConfigure(item: String, with: Any)

    public var explanation: String {
        switch self {
        case .taskFailed(let taskName, let command):
            return "\(taskName) failed at command: \(command)"
        case .configurationParsing:
            return "Error parsing configuration file."
        case .cannotConfigure(let item, let with):
            return "Cannot configure \(item) with \(with)"
        }
    }
}
