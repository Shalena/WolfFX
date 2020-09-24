//
//  AssetPriceJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/8/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let assetPriceKeys = ["bid", "price", "assetId", "priceTime", "status", "ask"]

class AssetPriceJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        var keys = [String]()
        for (key, _) in json {
            keys.append(key)
        }
        if containSameElements(firstArray: assetPriceKeys, secondArray: keys) {
            let bid = json["bid"] as? Double
            let price = json["price"] as? Double
            let assetId = json["assetId"] as? Int64
            if assetId != WSManager.shared.dataReceiver?.selectedAsset?.id {  // fix for the situation when you change asset, but still are subscribed to the previous asset, so price for previuous asset continues to come
                return false
            }
            let priceTime = json["priceTime"] as? Int64
            let status = json["status"] as? Bool
            let ask = json["ask"] as? Double
            let assetPrice = AssetPrice(price: price, assetId: assetId, status: status, priceTime: priceTime, ask: ask, bid: bid)
            WSManager.shared.dataReceiver?.assetPrice = assetPrice
            return true
        } else {
            return false
        }
    }
    
    
   private func containSameElements(firstArray: [String], secondArray: [String]) -> Bool {
          if firstArray.count != secondArray.count {
              return false
          } else {
              return firstArray.sorted() == secondArray.sorted()
          }
      }
    
    
}
