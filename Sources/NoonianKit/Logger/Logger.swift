//
//  Printer.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/7/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Rainbow

public var log: Logger.Type = FancyLogger.self

public protocol Logger {
    static func start(_: String)
    static func info(_: String)
    static func end(_: String)
    static func error(_: String)
}

public struct FancyLogger: Logger {
    public static func start(_ item: String) {
        let message = ["***".lightCyan, "Starting:", item.bold].joined(separator: " ").underline
        print(message)
    }

    public static func info(_ info: String) {
        print(info.lightBlack)
    }

    public static func end(_ item: String) {
        let message = ["***".lightGreen, "Completed:", item.bold].joined(separator: " ").underline
        print(message)
    }

    public static func error(_ error: String) {
        let message = ["***".lightRed, "Error:", error.bold].joined(separator: " ").underline
        print(message)
    }
}
