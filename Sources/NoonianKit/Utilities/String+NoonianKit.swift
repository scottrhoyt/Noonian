//
//  String+NoonianKit.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

public extension String {
    func pathByAdding(component: String) -> String {
        var path = self
        var component = component

        if !path.isEmpty && path.characters.last == "/" { path.remove(at: path.index(before: path.endIndex)) }
        if !component.isEmpty && component.characters.first == "/" { component.remove(at: component.startIndex) }

        return path + "/" + component
    }

    var isAbsolutePath: Bool {
        return characters.first == "/"
    }

    public func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String {
        if isAbsolutePath {
            return self as String
        }

        return rootDirectory.pathByAdding(component: self)
    }
}
