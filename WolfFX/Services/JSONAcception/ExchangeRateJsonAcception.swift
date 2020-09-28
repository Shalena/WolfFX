
//
//  ExchangeRateAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/21/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class ExchangeRateJsonAcception {
    func accept(json: JSON) {
        if let rate = json["rate"] as? Double,
            let withdraw = json["withdrawRate"] as? Double {
            WSManager.shared.dataReceiver.rate = rate
            WSManager.shared.dataReceiver.withdrawRate = withdraw
        }  
    }
}
