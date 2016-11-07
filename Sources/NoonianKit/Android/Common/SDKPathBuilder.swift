//
//  SDKPathBuilder.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/6/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

fileprivate enum Paths: String {
    case tools = "tools"
    case buildTools = "build-tools"
    case platformTools = "platform-tools"
    case platforms = "platforms"
    case platformIncludeName = "android.jar"
}

fileprivate enum Tools: String {
    case android = "android"
    case emulator = "emulator"
    case package = "aapt"
    case jack = "jack.jar"
    case zipAlign = "zipalign"
    case adb = "adb"
}

struct SDKPathBuilder {
    let androidHome: String

    private func buildToolsBaseDir() -> String {
        return androidHome.pathByAdding(component: Paths.buildTools.rawValue)
    }

    func androidToolCommand() -> String {
        return androidHome
            .pathByAdding(component: Paths.tools.rawValue)
            .pathByAdding(component: Tools.android.rawValue)
    }

    // This function will return the path to the versioned tools if provided
    // Otherwise it will return the latest tools installed
    private func buildToolsPath(toolsVersion: String? = nil) throws -> String {
        let baseDir = buildToolsBaseDir()

        if let toolsVersion = toolsVersion {
            return baseDir.pathByAdding(component: toolsVersion)
        }

        let contents = try FileManager.default.contentsOfDirectory(atPath: baseDir)

        if let latest = contents.sorted(by: >).first {
            print("Tools Version not supplied. Using latest.")
            print(baseDir.pathByAdding(component: latest))
            return baseDir.pathByAdding(component: latest)
        } else {
            throw NoonianError.noBuildTools
        }
    }

    func includeFor(target: String) -> String {
        return androidHome
            .pathByAdding(component: Paths.platforms.rawValue)
            .pathByAdding(component: target)
            .pathByAdding(component: Paths.platformIncludeName.rawValue)
    }

    func packageToolCommand(toolsVersion: String?) throws -> String {
        return try buildToolsPath(toolsVersion: toolsVersion)
            .pathByAdding(component: Tools.package.rawValue)
    }

    func jackToolCommand(toolsVersion: String?) throws -> String {
        let jackPath = try buildToolsPath(toolsVersion: toolsVersion)
            .pathByAdding(component: Tools.jack.rawValue)
        let command = "java -jar " + jackPath
        return command
    }

    func zipAlignToolCommand(toolsVersion: String?) throws -> String {
        return try buildToolsPath(toolsVersion: toolsVersion)
            .pathByAdding(component: Tools.zipAlign.rawValue)
    }

    func adbToolCommand() -> String {
        return androidHome
            .pathByAdding(component: Paths.platformTools.rawValue)
            .pathByAdding(component: Tools.adb.rawValue)
    }
}
