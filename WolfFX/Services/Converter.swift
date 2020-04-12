//
//  Converter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Converter {
    func realBalanceString(from balance: Double?, currencyString: String?, bonus: Double?) -> String {
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
        let realBalanceTruncate = realBalance.truncate(places: 2)
        let realBalanceString = String(realBalanceTruncate)
        let resultString = [currencySign, realBalanceString].joined(separator: " ")
        return resultString
    }
    
    func realBalanceStructure(from balance: Double?, bonus: Double?, amauntPendingWithdraw: Double?, dateFrom: TimeInterval?) {
        
        if let balance = balance {
           let balanceString = String(balance.truncate(places: 2))
        }
        
        if let bonus = bonus {
            let bonusString = String(bonus.truncate(places: 2))
        }
        
        if let amauntPendingWithdraw = amauntPendingWithdraw {
            let amauntPendingWithdrawString = String(amauntPendingWithdraw.truncate(places: 2))
        }
        
        if let time = dateFrom {
            let date = Date(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            let dateFromString = dateFormatter.string(from: date)
        }
    }
    
    func jsonToString(json: JSON) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return (convertedString) // <-- here is ur string

        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
}

