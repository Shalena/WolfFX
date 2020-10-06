//
//  WalletPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/18/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

let banksJsonValues =  [
    ["value": "ICBC", "name": "Industrial and Commercial Bank of China"],
    ["value": "ABC", "name": "Agricultural Bank of China"],
    ["value": "BOC", "name": "Bank of China"],
    ["value": "CCB", "name": "China Construction Bank"],
    ["value": "CMB", "name": "China Merchant Bank"],
    ["value": "COMM", "name": "Bank of Communications"],
    ["value": "CEB", "name":  "China Everbright Bank"],
    ["value": "CMBC", "name": "China Minsheng Bank" ],
    ["value": "CIB", "name": "China Indusrial Bank"],
    ["value": "SPABANK", "name": "Pingan Bank"],
    ["value": "CITIC", "name": "China Citic Bank"],
    ["value": "HXB", "name": "Huaxia Bank"],
    ["value": "SPDB", "name": "Shanghai Pudong Development Bank"],
    ["value": "GDB", "name": "Guangdong Development Bank"],
    ["value": "POSTGC", "name": "Postal Savings Bank of China"]
]

var methodPickerStrings = {
    return [R.string.localizable.chinaUnionPay().localized()]
}

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
    var rate: Double?
    var withdrawRate: Double?
    var pickerDataSource: [String]?
    lazy var pickerBankDataSource: [BankPikerEntry]? = {
        var pickerEntries = [BankPikerEntry]()
        for dict in banksJsonValues {
            let value = dict["value"]
            let name = dict["name"]
            let pickerEntry = BankPikerEntry(title: name ?? "", value: value ?? "")
            pickerEntries.append(pickerEntry)
        }
        return pickerEntries
    }()

    init (with view: WalletViewProtocol, networkManager: NetworkAccess, router: WalletTransitions) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        self.pickerDataSource = methodPickerStrings()
    }
    
    func forceLocalizeUpdatePicker() {
        self.pickerDataSource = methodPickerStrings()
    }
    
    func walletViewIsReady() {
        getExchangeRate()
        WSManager.shared.getBanks()
    }
       
    func getExchangeRate() {
        view?.showHud()
        networkManager?.getExchangeRate(with: defaultBroker, success: { successfully in
            self.view?.hideHud()
            self.rate = WSManager.shared.dataReceiver.rate
            self.withdrawRate = WSManager.shared.dataReceiver.withdrawRate
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
            let exchangeValue = withdrawRate * value
            updateViewWithRMB(value: exchangeValue)
        }
    }
    
    private func updateViewWithRMB(value: Double) {
           let string = String(value.truncate(places: 2))
        let fullString = R.string.localizable.rmbToBePaid() + " " + string
           view?.updateRMBLabel(with: fullString)
       }
    
    private func updateViewWith(poundValue: Double) {
        let string = String(poundValue.truncate(places: 2))
        let fullString = "£" + " " + string
        view?.updateExchangeDepositLabel(with: fullString)
    }
    
    func textForAvailableAmount() -> String {
        var balance = ""
        if let balanceValue = WSManager.shared.dataReceiver.billingData.balance {
            balance = balanceValue
        }
        return String(format: R.string.localizable.amountAvailable(balance))
    }
    
    func deposit(with amount: String) {
        guard let user = WSManager.shared.dataReceiver.user else {return}
        if let amountValue = Double(amount),let currency = user.currency, let accountNumber = user.email, let rate = rate {
            networkManager?.deposit(with: amountValue, currency: currency, accountNumber: accountNumber, exchangeRate: rate, success: { string in
                DispatchQueue.main.async {
                     self.view?.loadWebView(string: string)
                }
            }, failure: { error in
                if let error = error {
                    self.view?.showErrorAlertWith(error: error)
                }
            })
        }
    }
    
    func withdrawRequestWith(form: WithdrawForm) {
        guard let user = WSManager.shared.dataReceiver.user,
            let currency = user.currency,
            let accountNumber = user.email,
            let name = user.firstName else {return}
            var bankParameter = ""
            if let bank = pickerBankDataSource?.first(where: {$0.title == form.bankName}) {
                bankParameter = bank.value
            }
        networkManager?.withdraw(amount: form.amaunt, beneficiaryBankAccount: form.beneficiaryBankAccount, beneficiaryName: form.beneficiaryName, accountNumber: accountNumber, broker: defaultBroker, url: withdrawUrl, billingServer: billingServer, tenantId: tenantId, currency: currency, name: name, method: method, bankName: bankParameter, success: { successfully in
                self.view?.showAlertWith(text: "Sent successfully")
            }, failure: { error in
                if let error = error {
                    self.view?.showErrorAlertWith(error: error)
                }
            })
        }
}
