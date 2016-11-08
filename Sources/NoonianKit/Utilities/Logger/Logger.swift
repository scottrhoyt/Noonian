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
    static func process(_: String)
    static func info(_: String)
    static func complete(_: String)
    static func error(_: String)
}

public struct FancyLogger: Logger {
    public static func start(_ item: String) {
        let message = ["▶️ ", "Starting:", item.bold].joined(separator: " ")
        print(spaced(message))
    }

    public static func process(_ output: String) {
        print(output.lightBlack, separator: " ", terminator: "")
    }

    public static func info(_ info: String) {
        print(info.lightCyan)
    }

    public static func complete(_ item: String) {
        let message = ["✅ ", "Completed:", item.bold].joined(separator: " ")
        print(spaced(message))
    }

    public static func error(_ error: String) {
        let message = ["⛔️ ", "Error:", error.bold].joined(separator: " ")
        print(spaced(message, fence: ""))
    }

    private static func spaced(_ string: String, fence: String = "=") -> String {
        let separator = repeatElement(fence, count: 80).joined()
        return ["", separator, string, separator, ""].joined(separator: "\n")
    }
}
