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
    
    func balanceData(from balance: Double?, bonus: Double?, amauntPendingWithdraw: Double?, dateTo: TimeInterval?) -> BillingData {
        var balanceString = ""
        var bonusString = ""
        var amauntPendingWithdrawString = ""
        var dateFromString = ""
        var dateToString = ""
        
        if let balance = balance {
            balanceString = String(balance.truncate(places: 2))
        }
        
        if let bonus = bonus {
            bonusString = String(bonus.truncate(places: 2))
        }
        
        if let amauntPendingWithdraw = amauntPendingWithdraw {
            amauntPendingWithdrawString = String(amauntPendingWithdraw.truncate(places: 2))
        }
        
        if let time = dateTo {
            let date = Date(timeIntervalSince1970: (time / 1000.0))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateToString = dateFormatter.string(from: date)
            let dateFrom = date.startOfMonth()
            dateFromString = dateFormatter.string(from: dateFrom)
        }
        let billingData = BillingData(with: balanceString,  bonus: bonusString, amauntPendingWithdrawal: amauntPendingWithdrawString, dateFrom: dateFromString, dateTo: dateToString)
            return billingData
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

