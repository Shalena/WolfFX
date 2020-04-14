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
    var networkManager: NetworkAccess?
    var websocketManager: WebsocketAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    
    init (with view: BillingDataViewProtocol, networkManager: NetworkAccess, router: BillingDataTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.websocketManager = WSManager.shared
        self.router = router
        dataReceiver = DataReceiver.shared
    }

    func billingDataViewIsReady() {
        let billingData = DataReceiver.shared.billingData
        view?.updateViewWith(data: billingData)
        observe()
    }
    
    private func observe() {
        observation = observe(\.dataReceiver?.billingData, options: [.old, .new]) { object, change in
            if let billingData = change.newValue as? BillingData {
                self.view?.updateViewWith(data: billingData)
            }            
        }
    }
    
    func showRange() {
        networkManager?.getBillingHistory(success: { successfully in
            self.websocketManager?.connect()
        }, failure: { error in
            
        })
    }
}
