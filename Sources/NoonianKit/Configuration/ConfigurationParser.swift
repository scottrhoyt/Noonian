//
//  ConfigurationParser.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

protocol ConfigurationParser {
    func parse(contents: String) throws -> [String: Any]
}

extension ConfigurationParser {
    func loadFile(at path: String) throws -> String {
        return ""
    }

    func parseFile(at path: String) throws -> [String: Any] {
        let contents = try loadFile(at: path)
        return try parse(contents: contents)
    }
}
