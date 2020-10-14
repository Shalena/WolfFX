//
//  BalanceHistoryJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 10/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let balanceHistory = "history"

class BalanceHistoryJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        if let balanceHistoryJsonArray = json[balanceHistory] as? [JSON] {
            var array = [BalanceHistoryItem]()
            for json in balanceHistoryJsonArray {
                let jsonString = Converter().jsonToString(json: json)
                if let jsonData = jsonString?.data(using: .utf8){
                    if let balanceHistoryItem = try? JSONDecoder().decode(BalanceHistoryItem.self, from: jsonData) {
                        array.append(balanceHistoryItem)
                    }
                }
            }
            WSManager.shared.dataReceiver.balanceHistoryItems = array
            return true
         } else {
            return false
        }
    }
}
