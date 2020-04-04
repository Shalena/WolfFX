//
//  Converter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Converter {
    func realBalance (from balance: Double?, currencyString: String?, bonus: Double?) -> String {
        var currencySign = ""
        var balancePart: Double = 0.00
        var bonusPart: Double = 0.00
        
        if let balance = balance {
            balancePart = balance
        }
        
        if let bonus = bonus {
            bonusPart = bonus
        }
        
        if let currency = currencyString, let sign = Currency(rawValue: currency)?.sign {
            currencySign = sign
        }
      
        let realBalance = balancePart + bonusPart
        let realBalanceString = String(realBalance)
        let resultString = [currencySign, realBalanceString].joined(separator: " ")
        return resultString
    }
}

