//
//  AssetDataSource.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

struct AssetsDataSource {
    var currencies: [Asset]?
    var indicies: [Asset]?
    var commodities: [Asset]?
    var sentiments: [Asset]?
    var numberOfCategories = AssetType.all.count
    let sectionTitles = ["CURRENCIES", "INDICIES", "COMMODITIES", "SENTIMENTS"]
}
