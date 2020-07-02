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
