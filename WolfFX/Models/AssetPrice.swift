//
//  AssetPrice.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/8/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class AssetPrice: NSObject {
    var price: Double?
    var assetId: Int64?
    var status: Bool?
    var priceTime: Int64?
    var ask: Double?
    var bid: Double?
    var label: String?
    
    init(price: Double?, assetId: Int64?, status: Bool?, priceTime: Int64?, ask: Double?, bid: Double?) {
        self.price = price
        self.assetId = assetId
        self.status = status
        self.priceTime = priceTime
        self.ask = ask
        self.bid = bid
        if let time = priceTime, let intTime = Int(exactly: time) {
            let dateValue = Date(timeIntervalSince1970: TimeInterval(intTime / 1000))
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let label = formatter.string(from: dateValue)
            self.label = label
        }       
    }
}
