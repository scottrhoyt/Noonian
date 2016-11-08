//
//  ConfigurableItem.swift
//  Noonian
//
//  Created by Scott Hoyt on 11/2/16.
//  Copyright © 2016 Scott Hoyt. All rights reserved.
//

import Foundation

protocol ConfigurableItem {
    init(name: String, configuration: Any) throws
}
