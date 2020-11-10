//
//  Converter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class Converter {
     private func realBalanceHeaderString(from realMoney: Double?, currencyString: String?, bonus: Double?) -> String {
        var currencySign = ""
        var realMoneyPart: Double = 0.00
        var bonusPart: Double = 0.00
        
        if let realMoney = realMoney {
            realMoneyPart = realMoney
        }
        
        if let bonus = bonus {
            bonusPart = bonus
        }
        
        if let currency = currencyString, let sign = Currency(rawValue: currency)?.sign {
            currencySign = sign
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        let realBalance = realMoneyPart + bonusPart
        let realBalanceString =  formatter.string(from: NSNumber(value: realBalance.truncate(places: 2))) ?? ""
        let resultString = [currencySign, realBalanceString].joined(separator: " ")
        return resultString
    }
    
    func accountData(from realMoney: Double?, bonus: Double?, amauntPendingWithdraw: Double?, dateTo: TimeInterval?, currencyString: String?) -> AccountData {
        var realMoneyString = "0.0"
        var bonusString = "0.0"
        var amauntPendingWithdrawString = "0.0"
        var dateFromString = ""
        var dateToString = ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
 
        if let realMoney = realMoney {
            realMoneyString = formatter.string(from: (NSNumber(value: realMoney.truncate(places: 2)))) ?? ""
        }
        
        if let bonus = bonus {
            bonusString = formatter.string(from: (NSNumber(value: bonus.truncate(places: 2)))) ?? ""
        }
        
        if let amauntPendingWithdraw = amauntPendingWithdraw {
            amauntPendingWithdrawString = formatter.string(from: (NSNumber(value: amauntPendingWithdraw.truncate(places: 2)))) ?? ""
        }
        
        var timeIntervalFrom: Double?
        
        if let time = dateTo {
            let date = Date(timeIntervalSince1970: (time / 1000.0))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            dateToString = dateFormatter.string(from: date)
            let dateFrom = date.startOfMonth()
            timeIntervalFrom = dateFrom.timeIntervalSince1970
            dateFromString = dateFormatter.string(from: dateFrom)
        }
        
        let balanceHeaderString = realBalanceHeaderString(from: realMoney, currencyString: currencyString, bonus: bonus)
        let viewModel = AccountDataViewModel(with: balanceHeaderString, realMoney: realMoneyString, bonus: bonusString, amauntPendingWithdrawal: amauntPendingWithdrawString, dateFrom: dateFromString, dateTo: dateToString)
        let userCanPlay: Bool?
        if let realMoney = realMoney, realMoney > 0.0 {
            userCanPlay = true
        } else {
            userCanPlay = false
        }
        
        let accountData = AccountData(with: viewModel, realBalanceHeaderString: balanceHeaderString, userCanPlay: userCanPlay, timeIntervalFrom: timeIntervalFrom, timeIntervalTo: dateTo)
        return accountData
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
    
    func maxString(from max: Double) -> String {
        let valueString = String(max.truncate(places: 2))
        return ["max:", valueString].joined(separator: " ")
    }
    
    func minString(from max: Double) -> String {
        let valueString = String(max.truncate(places: 2))
        return ["min:", valueString].joined(separator: " ")
    }
}

