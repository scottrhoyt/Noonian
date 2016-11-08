//
//  YamlConfigurationParser.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Yaml

struct YamlParser: Parser {
    init() { }

    func parse(contents: String) throws -> [String : Any] {
        guard let parsed = try? Yaml.load(contents), let dictionary = parsed.flatDictionary else {
            throw UtilityError.configurationParsing
        }

        return dictionary
    }
}
