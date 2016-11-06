//
//  NoonianKitError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public enum NoonianKitError: Error {
    case invalidConfiguration
    case configurationParsing
    case duplicateConfigurations(items: [String])
    case unknownConfigurationItems(items: [String])
    case unknownConfigurationOption(item: String, Option: Any)
}
