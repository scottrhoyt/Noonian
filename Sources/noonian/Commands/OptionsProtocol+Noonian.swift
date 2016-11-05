//
//  OptionsProtocol+Noonian.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import NoonianKit

enum EnvironmentKeys: String {
    case androidHome = "ANDROID_HOME"
}

extension OptionsProtocol {
    static var androidHomeOption: Option<String?> {
        return envOption(
            key: "android-home",
            envName: EnvironmentKeys.androidHome.rawValue,
            usage: "The path to the Android SDK. Defaults to $PATH."
        )
    }

    static func envOption(key: String, envName: String, usage: String) -> Option<String?> {
        let envVal = Environment().stringValue(for: envName)
        let extendedUsage = [
            usage,
            "Can be provided with $\(envName)"
            ].joined(separator: "\n")
        return Option(key: key, defaultValue: envVal, usage: extendedUsage)
    }
}
