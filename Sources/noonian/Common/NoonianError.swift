//
//  NoonianError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/5/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

enum NoonianError: Error {
    case unknown
    case androidHomeNotDefined

    var description: String {
        switch self {
        case .unknown:
            return "An unknown error has occurred."
        case .androidHomeNotDefined:
            return "\(EnvironmentKeys.androidHome.rawValue) is not defined"
        }
    }
}
