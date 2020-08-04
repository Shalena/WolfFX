//
//  WebsocketJsonCreator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let priceHistoryDuration: Int64 = 300

class WebsocketJsonCreator {
    
    func registerJSON()  -> [String : Any]? {
        guard let email = DataReceiver.shared?.user?.email else {return nil}
        let clientString = String(format: "client-%@", email)
        return ["type": "register",
                "address": clientString,
                "headers": [:],
                "body" : [:],
                "replyAddress": ""]
    }
    
    func assetRange(rangeId: String, leverage: Int64, timeDuration: Int64, type: String, currency: String, assetId: Int64, stake: Int64, username: String) -> [String : Any] {
        return ["type": "send",
                "address": "AssetRange",
                "headers": [:],
                "body" : ["rangeId": rangeId,
                          "timeDuration": timeDuration,
                          "leverage": leverage,
                          "type": type,
                          "assetId": assetId,
                          "stake":stake,
                          "currency": currency,
                          "username": username],
                "replyAddress": ""]
    }
    
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double, currency: String) -> [String : Any] {
        return ["type": "send",
        "address": "OrderExecutor",
        "headers": [:],
        "body" : ["range": [
                    "rangeId": rangeId,
                    "leverage": leverage,
                    "currency": currency,
                    "min": min,
                    "max":max]],
        "replyAddress": ""]
    }
    
    func getPriceHistoryJSON(assetId: Int64) -> [String : Any] {
           return ["type": "send",
           "address": "PriceHistoryRequests",
           "headers": [:],
           "body" : ["assetId": assetId,
                     "durationSec": priceHistoryDuration],
           "replyAddress": ""]
       }
}


