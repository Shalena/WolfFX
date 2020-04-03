//
//  Converter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Converter {
    func realBalance (from balance: String, currency: String, bonus: String) -> String {
        if let balance = Float(balance), let bonus = Float(bonus), let currencySignString = Currency(rawValue: currency)?.sign {
            let realBalanceString = String(balance + bonus)
            let resultString = [currencySignString, realBalanceString].joined(separator: " ")            
            return resultString
        } else {
            return ""
        }
    }
}

