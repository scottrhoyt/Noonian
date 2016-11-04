//
//  Task.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

// TODO: Task protocol serves no purpose right now
protocol Task {
    var name: String { get }
}

protocol ConfigurableTask: Task {
    init(configuration: Any) throws
}
