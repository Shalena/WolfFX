//
//  Asset.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/1/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum AssetType: String {
    case currency = "CURRENCY"
    case indices = "INDICES"
    case commodities = "COMMODITY"
    case sentiment = "SENTIMENT"
    static let all = [currency, indices, commodities, sentiment]
}

class Asset: NSObject {
    var name: String?
    var id: Int64?
    var assetType: AssetType?
    
    init(name: String?, id: Int64?, type: AssetType?) {
        super.init()
        self.name = name
        self.id = id
        self.assetType = type
    }
}
