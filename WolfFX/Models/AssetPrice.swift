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
    
    init(price: Double?, assetId: Int64?, status: Bool?, priceTime: Int64?, ask: Double?, bid: Double?) {
        self.price = price
        self.assetId = assetId
        self.status = status
        self.priceTime = priceTime
        self.ask = ask
        self.bid = bid
    }
}
