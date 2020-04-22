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

let cardType = "D"
let merchantTradeId = "SP20042301473922100"
let version = "1.0"
let issuingBank = "UNIONPAY"
let payType = "CARDBANK"
let merchantId = "6199"
let signType = "RSA"
let notifyUrl = "https://api.swiftpay.solutions/payment/OnepayC2C/c2c/notifyUrl.html"
let inputCharset = "UTF-8"
let currency = "CNY"
let goodsTitle = "C2C"
let returnUrl = "https://api.swiftpay.solutions/payment/OnepayC2C/c2c/returnUrl.html"

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
            if let error = error {
                self.view?.showErrorAlertWith(error: error)
            }
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
    
    func deposit(with amount: String) {
        if let amountValue = Double(amount) {
            networkManager?.deposit(with: nil, amountFee: amountValue, sign: nil, cardType: cardType, merchantTradeId: merchantTradeId, userName: nil, version: version, paymentCard: nil, issuingBank: issuingBank, payType: payType, merchantId: merchantId, payIp: nil, signType: signType, notifyUrl: notifyUrl, inputCharset: inputCharset, currency: currency, goodsTitle: goodsTitle, returnUrl: returnUrl, subIssuingBank: nil, success: { successfully in
                self.view?.showAlertWith(text: "Sent successfully")
            }, failure: { error in
                if let error = error {
                    self.view?.showErrorAlertWith(error: error)
                }
            })
        }
    }
    
    func withdrawRequestWith(form: WithdrawForm) {
        
    }

}
