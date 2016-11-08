//
//  Environment.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public struct Environment {
    public init() { }

    public func stringValue(for key: String) -> String? {
        guard let rawValue = getenv(key) else { return nil }
        return String(utf8String: rawValue)
    }

    public func set(value: String, for key: String, overwrite: Bool = true) {
        setenv(key, value, overwrite ? 1 : 0)
    }

    public func unset(for key: String) {
        unsetenv(key)
    }
}
