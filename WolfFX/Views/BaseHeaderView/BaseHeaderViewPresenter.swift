//
//  BaseHeaderViewPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/4/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BaseHeaderViewPresenter: NSObject {
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    var orderBonusObservation: NSKeyValueObservation?
    var view: BaseHeaderView?
    
    override init() {
        dataReceiver = WSManager.shared.dataReceiver
    }
    
    func observe() {      
        observation = observe(\.dataReceiver?.accountData, options: [.old, .new]) { object, change in
            if let accountData = change.newValue as? AccountData,
                let realBalanceHeaderString = accountData.realBalanceHeaderString {
                self.view?.updateWith(realBalance: realBalanceHeaderString)
            }
        }
            orderBonusObservation = observe(\.dataReceiver?.orderBonus, options: [.old, .new]) { object, change in
                if let orderBonus = change.newValue as? OrderBonus,
                   let bonusOut = orderBonus.bonusOut,
                   let bonusIn = orderBonus.bonusIn,
                    let currenyCode = orderBonus.currencyCode,
                    let percent = orderBonus.percent {
                    var string: String?
                    var currencySign: String?
                    if let sign = Currency(rawValue: currenyCode)?.sign {
                        currencySign = sign
                    }
                if bonusIn > 0.0 && bonusOut == 0 {
                    string = String(bonusIn.truncate(places: 2)) + (currencySign ?? "")
                } else if bonusIn > 0.0 && bonusOut > 0.0 {
                    let inPart = String(bonusIn.truncate(places: 2)) + (currencySign ?? "")
                    let outPart = String(bonusOut.truncate(places: 2)) + (currencySign ?? "")
                    string = inPart + " + " + outPart
                }
                DispatchQueue.main.async {
                    self.view?.updateBonus(with: string)
                    self.view?.rotateArrow(percent: percent)
                }
            } else {
                DispatchQueue.main.async {
                    self.view?.returnSpeedometerToInitialState()
                }
            }
        }
    }
}
