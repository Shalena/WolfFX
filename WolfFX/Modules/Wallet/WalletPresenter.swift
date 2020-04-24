//
//  WalletPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/18/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let methodPickerStrings = ["China Union Pay"]

// Deposit Constants
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


// Withdraw constants
let defaultBroker = "KAIZEN_LOGIC_OPTIONS"
let withdrawUrl = "https://staging.cuboidlogic.com/wolffx/wallet/withdraw"
let billingServer = "IRELAND"
let tenantId = "00000000-0000-0000-0000-000000000000"
let method = "SWIFTPAY"
    
struct WithdrawForm {
    var amaunt: Double
    var bankName: String
    var beneficiaryBankAccount: String
    var beneficiaryName: String
}

class WalletPresenter: WalletEvents {
   
    var view: WalletViewProtocol?
    var router: WalletTransitions?
    var networkManager: NetworkAccess?
    var pickerDataSource: [String]?
    var rate: Double?
    var withdrawRate: Double?

    init (with view: WalletViewProtocol, networkManager: NetworkAccess, router: WalletTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        self.pickerDataSource = methodPickerStrings
    }
    
    func walletViewIsReady() {
        getExchangeRate()
    }
       
    func getExchangeRate() {
        networkManager?.getExchangeRate(with: defaultBroker, success: { successfully in
            self.rate = DataReceiver.shared.rate
            self.withdrawRate = DataReceiver.shared.withdrawRate
        }, failure: { error in
            if let error = error {
                self.view?.showErrorAlertWith(error: error)
            }
        })
    }
    
    func amountDepositChanged(text: String) {
        if let value = Double(text), let rate = rate {
            let exchangeValue = value / rate
            updateViewWith(poundValue: exchangeValue)
        }
    }
    
    func amountWithdrawChanged(text: String) {
        if let value = Double(text), let withdrawRate = withdrawRate {
            let exchangeValue = withdrawRate / value
            updateViewWithRMB(value: exchangeValue)
        }
    }
    
    private func updateViewWithRMB(value: Double) {
           let string = String(value.truncate(places: 2))
           let fullString = "RMB to be paid" + " " + string
           view?.updateRMBLabel(with: fullString)
       }
    
    private func updateViewWith(poundValue: Double) {
        let string = String(poundValue.truncate(places: 2))
        let fullString = "£" + " " + string
        view?.updateExchangeDepositLabel(with: fullString)
    }
    
    func textForAvailableAmount() -> String {
        var balance = ""
        if let balanceValue = DataReceiver.shared.billingData.balance {
            balance = balanceValue
        }
        return String(format: "Amaunt (available %@)", balance)
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
        guard let user = DataReceiver.shared.user,
            let currency = user.currency,
            let accountNumber = user.email,
            let name = user.firstName else {return}

        networkManager?.withdraw(amount: form.amaunt, beneficiaryBankAccount: form.beneficiaryBankAccount, beneficiaryName: form.beneficiaryName, accountNumber: accountNumber, broker: defaultBroker, url: withdrawUrl, billingServer: billingServer, tenantId: tenantId, currency: currency, name: name, method: method, bankName: form.bankName, success: { successfully in
                self.view?.showAlertWith(text: "Sent successfully")
            }, failure: { error in
                if let error = error {
                    self.view?.showErrorAlertWith(error: error)
                }
            })
        }
}
