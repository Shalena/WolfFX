//
//  BillingDataPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BillingDataPresenter: NSObject, BillingDataEvents {
    var view: BillingDataViewProtocol?
    var router: BillingDataTransitions?
    var websocketManager: WebsocketAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    
    init (with view: BillingDataViewProtocol, router: BillingDataTransitions) {
        self.view = view
        self.websocketManager = WSManager.shared
        self.router = router
        dataReceiver = DataReceiver.shared
    }

    func observe() {
        observation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
                 
        }
    }
}
