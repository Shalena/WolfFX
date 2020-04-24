
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
        if let rateString = json["rate"] as? String, let rateDouble = Double (rateString),
            let withdrawRateString = json["withdrawRate"] as? String, let withdrawRateDouble = Double (withdrawRateString) {
            DataReceiver.shared.rate = rateDouble
            DataReceiver.shared.withdrawRate = withdrawRateDouble
        }  
    }
}
