//
//  NoonianError.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

enum NoonianError: Error {
    case unknownConfigurationItems(items: Set<String>)
    case unknownConfigurationOption(item: String, Option: Any)
}
