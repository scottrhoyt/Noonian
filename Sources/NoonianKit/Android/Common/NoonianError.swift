//
//  NoonianError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/5/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public enum NoonianError: Error {
    case unknown(Error)
    case androidHomeNotDefined
    case noBuildTools

    public var description: String {
        switch self {
        case .unknown(let error):
            return "An unknown error has occurred: \(error)"
        case .androidHomeNotDefined:
            return "\(EnvironmentKeys.androidHome.rawValue) is not defined"
        case .noBuildTools:
            return "Your SDK does not have any build tools."
        }
    }
}
