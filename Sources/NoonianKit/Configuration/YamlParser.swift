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
        var parsed: Yaml
        do {
            parsed = try Yaml.load(contents)
        } catch {
            throw NoonianError.configurationParsing
        }

        if let dictionary = parsed.flatDictionary {
            return dictionary
        } else {
            throw NoonianError.invalidConfiguration
        }
    }
}
