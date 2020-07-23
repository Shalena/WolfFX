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
    static var shared: DataReceiver? = DataReceiver()
    var assembler: Assembler?
    @objc dynamic var user: User? {
                set {
                    do {
                        let repository = try assembler?.resolve(UserAccessProtocol.self)
                        repository?.user = newValue
                    } catch {
                        return
                    }
                }
    
                get {
                    do {
                        let repository = try assembler?.resolve(UserAccessProtocol.self)
                        return repository?.user
                    } catch {
                        return nil
                    }
                }
            }
    
    @objc dynamic var realBalanceString = ""
    @objc dynamic var billingData = BillingData(with: nil,  bonus: nil, amauntPendingWithdrawal: nil, dateFrom: nil, dateTo: nil)
    var rate: Double?
    var withdrawRate: Double?
    @objc dynamic var assets: [Asset]?
    @objc dynamic var assetPrice: AssetPrice?
    @objc dynamic var priceHistory: [PriceEntry]?
    @objc dynamic var range: Range?
    @objc dynamic var tradeStatus: TradeStatus?
  
    func clean() {
        DataReceiver.shared = nil
    }
}
