//
//  AssetDataSource.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

struct AssetsDataSource {
    var grouppedAssets: [[Asset]?]   
    let sectionTitles = [R.string.localizable.currencies().uppercased(),
                         R.string.localizable.indices().uppercased(),
                         R.string.localizable.commodities().uppercased(),
                         R.string.localizable.sentiments().uppercased()]
}
