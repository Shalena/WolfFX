//
//  DataReceiver.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Swinject

class DataReceiver: NSObject {
    @objc dynamic var user: User?
    @objc dynamic var accountData: AccountData?
    var rate: Double?
    var withdrawRate: Double?
    @objc dynamic var assets: [Asset]?
    @objc dynamic var selectedAsset: Asset?
    @objc dynamic var assetPrice: AssetPrice?
    @objc dynamic var priceHistory: [PriceEntry]?
    @objc dynamic var range: Range?
    @objc dynamic var tradeStatus: TradeStatus?
    @objc dynamic var connectionClosed = false
    @objc dynamic var balanceHistoryItems: [BalanceHistoryItem]?
}
