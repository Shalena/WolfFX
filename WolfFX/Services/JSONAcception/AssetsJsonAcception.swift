//
//  AssetsJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/1/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let assetsKeys = ["nightPriceSetting", "data", "formalDays", "replyAddress"]

class AssetsJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        var keys = [String]()
        for (key, _) in json {
            keys.append(key)
        }
        if containSameElements(firstArray: assetsKeys, secondArray: keys) {
            guard let assetDicts = json["data"] as? [[String: Any]] else {return false}
            var assets = [Asset]()
            for dict in assetDicts {
                let name = dict["name"] as? String
                let id = dict["id"] as? Int64
                let type = dict["type"] as? String ?? ""
                let assetType = AssetType(rawValue: type) ?? nil
                let asset = Asset(name: name, id: id, type: assetType)
                assets.append(asset)
            }
            DataReceiver.shared.assets = assets
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
