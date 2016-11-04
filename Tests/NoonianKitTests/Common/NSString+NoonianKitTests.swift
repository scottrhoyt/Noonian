//
//  NSString+NoonianKitTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

extension NSString {
    public func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String {
        if isAbsolutePath {
            return self as String
        }
        return (NSString.path(withComponents: [rootDirectory, self as String]) as NSString).standardizingPath
    }
}
