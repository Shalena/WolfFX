//
//  OrderBonus.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/27/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let maxOrderBonusPersent = 0.1

class OrderBonus: NSObject {
    var bonus: Double?
    var percent: Double?
    var bonusIn: Double?
    var bonusOut: Double?
    var currencyCode: String?
    
    init (with order: Order)  {
        
        if let winBonusOut = order.winBonusOut,
            let winBonusIn = order.winBonusIn,
            let investment = order.investment,
            let currency = order.currency {
            if winBonusOut > 0 {
                bonus = winBonusOut
            } else {
                bonus = winBonusIn
            }
            percent = (bonus ?? 0) / (investment * maxOrderBonusPersent)
            bonusIn = winBonusIn
            bonusOut = winBonusOut
            currencyCode = currency
            
        }
    }
}

