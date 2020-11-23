//
//  OrderExecutorJSONAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 6/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let actionKeys = ["action", "payload"]

class OrderExecutorJSONAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        var keys = [String]()
        for (key, _) in json {
            keys.append(key)
        }
        if containSameElements(firstArray: actionKeys, secondArray: keys) {
           let action = json["action"] as? String
           let payload: JSON? = json["payload"] as? JSON
           if action == "newBalance" {
              if let newBalanceJSON = payload {
                 let accepted = BalanceJsonAcception().acceptJson(json: newBalanceJSON)
                 print(accepted)
              }
           }
           if action == "showNewOrder" {
            if let payloadJSON = json["payload"] as? JSON, let jsonstring = payloadJSON["order"] as? String {
                    if let jsonData = jsonstring.data(using: .utf8) {
                        if let order = try? JSONDecoder().decode(Order.self, from: jsonData) {
                            DispatchQueue.main.async {
                                let snapshot = Converter().shapshotFrom(order: order)
                                WSManager.shared.dataReceiver.newSnapshot = snapshot
                            }
                        }
                    }
                 }
            }
            
           if action == "updateLiveOrder" {
                 if let payloadJSON = json["payload"] as? JSON, let jsonstring = payloadJSON["order"] as? String {
                                 if let jsonData = jsonstring.data(using: .utf8) {
                                     if let order = try? JSONDecoder().decode(Order.self, from: jsonData) {
                                         DispatchQueue.main.async {
                                            let snapshot = Converter().shapshotFrom(order: order)
                                            WSManager.shared.dataReceiver.newSnapshot = snapshot
                                        }
                                     }
                                 }
                              }
            }
           if action == "showExpiredOrder" {
                if let payloadJSON = json["payload"] as? JSON, let jsonstring = payloadJSON["order"] as? String {
                        if let jsonData = jsonstring.data(using: .utf8) {
                            if let order = try? JSONDecoder().decode(Order.self, from: jsonData) {
                                DispatchQueue.main.async {
                                    let snapshot = Converter().shapshotFrom(order: order)
                                    WSManager.shared.dataReceiver.newSnapshot = snapshot
                                }
                            }
                        }
                    if let message = payloadJSON["message"] as? String {
                        let tradeStatus = TradeStatus(message: message, success: nil)
                        WSManager.shared.dataReceiver.tradeStatus = tradeStatus
                    }
                }
            }
           if action == "showMessage" {
            var message: String? = payload?["message"] as? String
            let messageType: String? = payload?["messageType"] as? String
            var success: Bool?
            if messageType == Status.success.rawValue {
                success = true
            } else if messageType == Status.error.rawValue {
            if message?.count == 0 || message == nil {
                message = "Error"
            }
                success = false
            }
            let tradeStatus = TradeStatus(message: message, success: success)
            WSManager.shared.dataReceiver.tradeStatus = tradeStatus
            }
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
