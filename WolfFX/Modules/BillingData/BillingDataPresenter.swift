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
        dataReceiver = WSManager.shared.dataReceiver
    }

    func billingDataViewIsReady() {
        if let accountData = dataReceiver?.accountData, let viewModel = accountData.viewModel {
            view?.updateViewWith(viewModel: viewModel)
            observe()
        }
    }
    
    private func observe() {
        observation = observe(\.dataReceiver?.accountData, options: [.old, .new]) { object, change in
            if let accountData = change.newValue as? AccountData, let viewModel = accountData.viewModel{
                self.view?.updateViewWith(viewModel: viewModel)
            }            
        }
    }
}
