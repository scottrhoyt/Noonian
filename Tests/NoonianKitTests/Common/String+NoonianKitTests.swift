//
//  NSString+NoonianKitTests.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/3/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

extension String {
    var isAbsolutePath: Bool {
        return characters.first == "/"
    }

    public func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String {
        if isAbsolutePath {
            return self as String
        }

        //let rootUrl = URL(fileURLWithPath: rootDirectory, isDirectory: true)
        //return URL(fileURLWithPath: self, relativeTo: rootUrl).absoluteString
        return rootDirectory + "/" + self
    }
}
