//
//  BalanceJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/6/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let balanceKey = "balance"
let currencyKey = "currency"
let bonusKey = "bonus"
let timeKey = "time"
let amauntPendingWithdrawalKey = "holdBalance"

class BalanceJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        var balance: Double?
        var currency: String?
        var bonus: Double?
        var time: TimeInterval?
        var amauntPendingWithdrawal: Double?
        
        let keys: [String] = json.map({ $0.key })
        if keys.contains(balanceKey) {
            for key in keys {
                if key == balanceKey {
                    balance = json[key] as? Double
                }
                else if key == currencyKey {
                    currency = json[key] as? String
                }
                else if key == bonusKey {
                    bonus = json[key] as? Double
                }
                else if key == timeKey {
                    time = json[key] as? Double
                }
                else if key == amauntPendingWithdrawalKey {
                    amauntPendingWithdrawal = json[key] as? Double
                }
            }
            let realBalanceString = Converter().realBalanceString(from: balance, currencyString: currency, bonus: bonus)
            DataReceiver.shared.realBalanceString = realBalanceString
            return true
        } else {
            return false
        }
    }
}
