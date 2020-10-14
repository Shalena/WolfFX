//
//  BalanceHistoryItem.swift
//  WolfFX
//
//  Created by Елена Острожинская on 10/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BalanceHistoryItem: NSObject, Codable {
    var acceptedTime: String?
    var amount: Double?
    var currency: String?
    var date: TimeInterval?
    var descriptionString: String?
    var metadata: String?
    var newBalance: Double?
    var prevBalance: Double?
    var source: String?
    var tradeId: String?
    var transactionType: String?
    
    enum CodingKeys: String, CodingKey {
        case acceptedTime
        case amount
        case currency
        case date
        case descriptionString = "description"
        case metadata
        case newBalance
        case prevBalance
        case source
        case tradeId
        case transactionType
       }
}
