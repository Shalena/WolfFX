//
//  WalletPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/18/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let defaultBroker = "KAIZEN_LOGIC_OPTIONS"
let pickerStrings = ["China Union Pay"]

struct WithdrawForm {
    var amaunt: Double?
    var bankName: String?
    var beneficiaryBankAccount: String?
    var beneficiaryName: String?
}

class WalletPresenter: WalletEvents {
    var view: WalletViewProtocol?
    var router: WalletTransitions?
    var networkManager: NetworkAccess?
    var pickerDataSource: [String]?
    var rate: Double?

    init (with view: WalletViewProtocol, networkManager: NetworkAccess, router: WalletTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        self.pickerDataSource = pickerStrings
    }
    
    func walletViewIsReady() {
        getExchangeRate()
    }
       
    func getExchangeRate() {
        networkManager?.getExchangeRate(with: defaultBroker, success: { successfully in
            self.rate = DataReceiver.shared.rate
        }, failure: { error in
            
        })
    }
    
    func amountChanged(text: String) {
        if let cnuValue = Double(text), let rate = rate {
            let poundValue = cnuValue / rate
            updateViewWith(poundValue: poundValue)
        }
    }
    
    private func updateViewWith(poundValue: Double) {
        let string = String(poundValue.truncate(places: 2))
        let fullString = "£" + " " + string
        view?.updateWith(poundValueString: fullString)
    }
    
    func withdrawRequestWith(form: WithdrawForm) {
        
    }

}
