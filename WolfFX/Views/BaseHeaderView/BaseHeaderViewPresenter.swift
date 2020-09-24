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
        observation = observe(\.dataReceiver?.realBalanceString, options: [.old, .new]) { object, change in
            if let realBalanceString = change.newValue as? String {
                self.view?.updateWith(realBalance: realBalanceString)
            }
        }
    }
}
