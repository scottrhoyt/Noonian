//
//  AndroidCommand.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/4/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation
import Commandant

protocol AndroidCommand: CommandProtocol { }

extension AndroidCommand {
    private var androidCommand: String {
        return "tools/android"
    }

    func getAndroidCommand(androidHome: String?) -> String {
        if let androidHome = androidHome {
            return androidHome.pathByAdding(component: androidCommand)
        } else {
            return androidCommand
        }
    }
}
