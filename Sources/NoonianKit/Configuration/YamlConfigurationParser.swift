//
//  YamlConfigurationParser.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Yaml

struct YamlConfigurationParser: ConfigurationParser {
    init() { }

    func parse(contents: String) throws -> [String : Any] {
        return [:]
    }
}
