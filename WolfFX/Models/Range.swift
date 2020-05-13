//
//  Range.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Range: NSObject, Codable {
    var currency: String?
    var leverage: Int64?
    var max: Double?
    var min: Double?
    var rangeId: String?
}
