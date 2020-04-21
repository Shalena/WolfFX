
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
        if let rateString = json["rate"] as? String, let rateDouble = Double (rateString) {
            DataReceiver.shared.rate = rateDouble
        }
  
    }
}
