//
//  RangeJsonAcception.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let rangeKey = "range"

class RangeJsonAcception: JsonAcception {
    func acceptJson(json: JSON) -> Bool {
        if let rangeJson = json[rangeKey] as? JSON {
            let rangeJsonString = Converter().jsonToString(json: rangeJson)
            if let jsonData = rangeJsonString?.data(using: .utf8){
                if let range = try? JSONDecoder().decode(Range.self, from: jsonData) {
                    print(range)
                    DataReceiver.shared.range = range
                }
            }
            return true
         } else {
            return false
        }
    }
}
