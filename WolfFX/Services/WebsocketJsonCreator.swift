//
//  WebsocketJsonCreator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let priceHistoryDuration: Int64 = 200

class WebsocketJsonCreator {
    
    func registerJSON()  -> [String : Any]? {
        guard let email = WSManager.shared.dataReceiver.user?.email else {return nil}
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
    
    func balanceiHistoryJSON(from: TimeInterval, to: TimeInterval) -> [String : Any] {
              return ["type": "send",
              "address": "BillingTransactions",
              "headers": [:],
              "body" : ["from": from,
                        "to": to],
              "replyAddress": ""]
          }
    
    func getPriceJSON(assetId: Int64) -> [String : Any] {
        let assetPriceString = "AssetPrice-%@-00000000-0000-0000-0000-000000000000"
        let assetIdString  = "\(assetId)"
        let stringWithFormat = String(format: assetPriceString, assetIdString)
        return ["type": "register",
             "address": stringWithFormat,
             "headers": [:],
                "body": [:],
        "replyAddress": ""]
    }
    
    func getOrdersHistoryJson(email: String,  assetId: Int64, minDate: Double, maxDate: Double) -> [String : Any] {        
        return ["type": "send",
             "address": "OrdersByUserAssetsTimes",
             "headers": [:],
                "body" : ["username": email,
                           "assetId": assetId,
                           "minDate": minDate,
                           "maxDate": maxDate],
         "replyAddress": ""]
    }
}


