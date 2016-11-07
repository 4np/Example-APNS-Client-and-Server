//
//  NSData+hexDescription.swift
//  client
//
//  Created by Jeroen Wesbeek on 03/11/16.
//  Copyright © 2016 Jeroen Wesbeek. All rights reserved.
//

import Foundation

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
