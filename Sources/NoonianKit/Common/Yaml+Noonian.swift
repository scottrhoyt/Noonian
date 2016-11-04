//
//  Yaml+Noonian.swift
//  SwiftLint
//
//  Created by Scott Hoyt on 12/28/15.
//  Copyright © 2015 Scott Hoyt. All rights reserved.
//

import Foundation
import Yaml

extension Yaml {
    var flatDictionary: [Swift.String: Any]? {
        if let dict = dictionary {
            var newDict: [Swift.String: Any] = [:]
            for (key, value) in dict {
                newDict[key.stringValue] = value.flatValue
            }
            return newDict
        } else if count == 0 || self == .null { // swiftlint:disable:this empty_count
            return [:]
        }

        return nil
    }

    var flatArray: [Any]? { return array?.map { $0.flatValue } }

    var flatValue: Any {
        switch self {
        case .bool(let myBool):
            return myBool
        case .int(let myInt):
            return myInt
        case .double(let myDouble):
            return myDouble
        case .string(let myString):
            return myString
        case .array:
            return flatArray! // This is valid because .Array will always flatten
        case .dictionary:
            return flatDictionary! // This is valid because .Dictionary will always flatten
        case .null:
            return NSNull()
        }
    }

    var stringValue: Swift.String {
        switch self {
        case .bool(let myBool):
            return myBool.description
        case .int(let myInt):
            return myInt.description
        case .double(let myDouble):
            return myDouble.description
        case .string(let myString):
            return myString
        case .array(let myArray):
            return myArray.description
        case .dictionary(let myDictionary):
            return myDictionary.description
        case .null:
            return "Null"
        }
    }
}
