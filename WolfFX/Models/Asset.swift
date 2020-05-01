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
}

struct Asset {
    var name: String?
    var id: Int64?
    var assetType: AssetType?
}
