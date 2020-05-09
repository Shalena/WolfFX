//
//  BaseHeaderViewPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/4/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BaseHeaderViewPresenter: NSObject {
    @objc dynamic var dataReceiver = DataReceiver.shared
    var observation: NSKeyValueObservation?
    var view: BaseHeaderView?
    
    func observe() {
             observation = observe(\.dataReceiver.realBalanceString,
                        options: [.old, .new]
                    ) { object, change in
                        if let realBalanceString = change.newValue {
                            self.view?.updateWith(realBalance: realBalanceString)
                        }
                        WSManager.shared.connect()
                        WSManager.shared.readAllStatuses()
                    }
         }
}
