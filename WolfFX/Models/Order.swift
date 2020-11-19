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
    var hasBonus: Bool?
    var holdBonuses: Bool?
    var investment: Double?
    var lowerBound: Double?
    var orderId: String?
    var partialWin: Bool?
    var payOut: Double?
    var percentWin: Double?
    var resultedPrice: Double?
    var startTime: TimeInterval?
    var status: String?
    var type: String?
    var upperBound: Double?
    var username: String?
    var winBonusIn: Double?
    var winBonusOut: Double?
    var balanceString: String? // to check
}

enum OrderStatus: String {
    case live = "LIVE"
    case expired = "EXPIRED"
}
