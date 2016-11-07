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

protocol AndroidCommand: CommandProtocol {
    typealias ClientError = NoonianError

    func run(_ options: Self.Options, androidHome: String) throws
}

extension AndroidCommand {

    // TODO: Maybe derive the app name from something else, like configuration or directory name
    var appName: String {
        return "App"
    }

    // MARK: - Paths

    func androidHome() throws -> String {
        guard let androidHome = Environment().stringValue(for: EnvironmentKeys.androidHome.rawValue) else {
            throw NoonianError.androidHomeNotDefined
        }
        return androidHome
    }

    private func buildToolsBaseDir() throws -> String {
        return (try androidHome()).pathByAdding(component: Paths.buildTools.rawValue)
    }

    func androidToolPath() throws -> String {
        return try androidHome()
            .pathByAdding(component: Paths.tools.rawValue)
            .pathByAdding(component: Tools.android.rawValue)
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
            print("Tools Version not supplied. Using latest.")
            print(baseDir.pathByAdding(component: latest))
            return baseDir.pathByAdding(component: latest)
        } else {
            throw NoonianError.noBuildTools
        }
    }

    func includeFor(target: String) throws -> String {
        return try androidHome()
            .pathByAdding(component: Paths.platforms.rawValue)
            .pathByAdding(component: target)
            .pathByAdding(component: Paths.platformIncludeName.rawValue)
    }

    func packageToolPath(buildTools: String) -> String {
        return buildTools
            .pathByAdding(component: Tools.package.rawValue)
    }

    func jackToolCommand(buildTools: String) -> String {
        let jackPath = buildTools
            .pathByAdding(component: Tools.jack.rawValue)
        let command = "java -jar " + jackPath
        return command
    }

    func zipAlignToolCommand(buildTools: String) -> String {
        return buildTools.pathByAdding(component: Tools.zipAlign.rawValue)
    }

    // TODO: Consider passing android home into all paths that need it
    // We could extract this all out to a android command builder
    func adbToolCommand() throws -> String {
        return try androidHome()
            .pathByAdding(component: Paths.platformTools.rawValue)
            .pathByAdding(component: Tools.adb.rawValue)
    }

    // MARK: - Running functions

    public func run(_ options: Self.Options) -> Result<(), NoonianError> {
        do {
            try run(options, androidHome: androidHome())
            return .success()
        } catch {
            return .failure((error as? NoonianError) ?? .internalError(error))
        }
    }

    func execute(commands: [ShellCommand]) throws {
        let task = CommandTask(name: verb, commands: commands)
        try execute(task: task)
    }

    func execute(task: CommandTask) throws {
        let runner = Runner()
        try runner.run(task: task)
    }

    func execute(commands: [ShellCommand], configuration: NoonianConfiguration) throws {
        let beforeTaskKey = "before_" + verb
        let afterTaskKey = "after_" + verb

        // TODO: Maybe put these in configuration
        let beforeTask = try? CommandTask(name: beforeTaskKey, configuration: configuration.value(for: beforeTaskKey))
        let afterTask = try? CommandTask(name: afterTaskKey, configuration: configuration.value(for: afterTaskKey))

        try [beforeTask, CommandTask(name: verb, commands: commands), afterTask].flatMap { $0 }.forEach(execute)
    }
}
