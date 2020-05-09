//
//  PriceHistoryJsonAcceptor.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/9/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class PriceEntry: NSObject {
var value: Double
var date: Date
var label: String

init(value: Double,
      date: Double) {
    self.value = value
    let dateValue = Date(timeIntervalSince1970: date / 1000)
    self.date = dateValue
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    let label = formatter.string(from: dateValue)
    self.label = label
   }
}

let priceHistoryKeys = ["from", "assetId", "durationSec", "data", "replyAddress", "to"]

class PriceHistoryJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        var keys = [String]()
        for (key, _) in json {
            keys.append(key)
        }
        if containSameElements(firstArray: priceHistoryKeys, secondArray: keys) {
            guard let array = json["data"] as? [[Double]] else { return false }
            var priceEntries = [PriceEntry]()
            for priceItem in array {
                let date = priceItem[0]
                let value = priceItem[1]
                let priceEntry = PriceEntry(value: value, date: date)
                priceEntries.append(priceEntry)
            }
            DataReceiver.shared.priceHistory = priceEntries
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
