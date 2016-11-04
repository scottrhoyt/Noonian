//
//  NoonianError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

enum NoonianError: Error {
    case duplicateConfigurations(items: [String])
    case unknownConfigurationItems(items: [String])
    case unknownConfigurationOption(item: String, Option: Any)
}
