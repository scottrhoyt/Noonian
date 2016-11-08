//
//  All.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/7/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct All: AndroidCommand {
    public typealias Options = NoOptions<NoonianKitError>

    public let verb = "all"
    public let function = "Build, package, and install an app."

    public init() { }

    func run(_ options: NoOptions<NoonianKitError>, paths: SDKPathBuilder) throws {
        try Build().run(options, paths: paths)
        try Package().run(options, paths: paths)
        try Install().run(options, paths: paths)
    }
}
