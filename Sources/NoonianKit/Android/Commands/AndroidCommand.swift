//
//  AndroidCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant
import Result

fileprivate enum SDKPaths: String {
    case android = "tools/android"
    case emulator = "tools/emulator"
    case buildTools = "build-tools"
    case platformTools = "platform-tools"
    case platforms = "platforms"
    case platformIncludeName = "android.jar"
    case packageTool = "aapt" // TODO: Need to come up with a better format for paths and tools
    case jackTool = "jack.jar"
}

protocol AndroidCommand: CommandProtocol {
    typealias ClientError = NoonianError

    func run(_ options: Self.Options) throws
}

extension AndroidCommand {
    func androidHome() throws -> String {
        guard let androidHome = Environment().stringValue(for: EnvironmentKeys.androidHome.rawValue) else {
            throw NoonianError.androidHomeNotDefined
        }
        return androidHome
    }

    private func buildToolsBaseDir() throws -> String {
        return (try androidHome()).pathByAdding(component: SDKPaths.buildTools.rawValue)
    }

    func androidToolPath() throws -> String {
        return (try androidHome()).pathByAdding(component: SDKPaths.android.rawValue)
    }

    public func run(_ options: Self.Options) -> Result<(), NoonianError> {
        do {
            try run(options)
            return .success()
        } catch {
            return .failure((error as? NoonianError) ?? .internalError(error))
        }
    }

    // TODO: Should provide an option to supply build tools via configuration file
    // This function will return the path to the versioned tools if provided
    // Otherwise it will return the latest tools installed
    func buildToolsPath(toolsVersion: String? = nil) throws -> String {
        let baseDir = try buildToolsBaseDir()

        if let toolsVersion = toolsVersion {
            return baseDir.pathByAdding(component: toolsVersion)
        }

        let contents = try FileManager.default.contentsOfDirectory(atPath: baseDir)

        if let latest = contents.sorted(by: >).first {
            print(baseDir.pathByAdding(component: latest))
            return baseDir.pathByAdding(component: latest)
        } else {
            throw NoonianError.noBuildTools
        }
    }

    func includeFor(target: String) throws -> String {
        return try androidHome()
            .pathByAdding(component: SDKPaths.platforms.rawValue)
            .pathByAdding(component: target)
            .pathByAdding(component: SDKPaths.platformIncludeName.rawValue)
    }

    func packageToolPath(buildTools: String) -> String {
        return buildTools.pathByAdding(component: SDKPaths.packageTool.rawValue)
    }

    func jackToolCommand(buildTools: String) -> String {
        let jackPath = buildTools.pathByAdding(component: SDKPaths.jackTool.rawValue)
        let command = "java -jar " + jackPath
        return command
    }
}
