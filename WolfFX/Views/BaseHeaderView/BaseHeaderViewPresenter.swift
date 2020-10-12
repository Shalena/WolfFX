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
    }
}
