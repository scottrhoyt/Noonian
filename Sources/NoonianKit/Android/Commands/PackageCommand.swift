//
//  PackageCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

public struct PackageCommand: AndroidCommand {
    public typealias Options = PackageOptions

    public let verb = "package"
    public let function = "Sign and package an app."

    public init() { }

    func run(_ options: PackageOptions) throws {
        //
    }
}

public struct PackageOptions: OptionsProtocol {
    public static func evaluate(_ m: CommandMode) -> Result<PackageOptions, CommandantError<NoonianError>> {
        return .success(PackageOptions())
    }
}
