//
//  Order.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/10/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Order: NSObject, Codable {
    var assetId: Int64?
    var currency: String?
    var expiryTime: TimeInterval?
    var failureTime: TimeInterval?
    var failureValue: Double?
    var hasBonus: Double?
    var holdBonuses: Double?
    var investment: Int64?
    var lowerBound: String?
    var orderId: String?
    var partialWin: Double?
    var payOut: Double?
    var percentWin: String?
    var resultedPrice: String?
    var startTime: TimeInterval?
    var status: String?
    var type: String?
    var upperBound: String?
    var username: String?
    var winBonusIn: String?
    var winBonusOut: String?
}
