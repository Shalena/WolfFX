//
//  Endpoints.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

let depositRedirectUrl = "https://staging.cuboidlogic.com/wolffx/wallet/deposit"
let chinaUnionPaydefault = "CNY"

typealias Parameters = [String: Any]
typealias Headers = [String: String]

enum httpMethod {
    case get
    case post
    case patch
    case put
}

enum Endpoint {
    case login(email: String, password: String)
    case restorePassword(email: String)
    case signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String)
    case billingHistory
    case exchangeRate (broker: String)
    case deposit(amount: Double, currency: String, accountNumber: String, exchangeRate: Double)
    case withdraw (amount: Double, bankName: String, beneficiaryBankAccount: String, beneficiaryName: String, accountNumber: String, broker: String, url: String, billingServer: String, currency: String, name: String, tenantId: String, method: String)
    case logout
    
    var path: String {
    switch self {
    case .login:
        return "/mt1/login"
    case .restorePassword:
        return "/rp/otp"
    case .signup:
        return "/mt1/createUser"
    case .logout:
        return "/mt1/logout"
    case .billingHistory:
        return "/wolffx/billingHistory"
    case .withdraw:
        return "/payapi/v1/withdrawal"
    case .exchangeRate:
        return "/payapi/v1/payins/GBP/exchangeRate"
    case .deposit:
        return "/payapi/v1/swiftpay/payins"
        }
    }
        
    var headers: Headers? {
    switch self {
    case .login, .restorePassword, .signup, .billingHistory, .exchangeRate, .deposit, .logout:
        return nil
    case .withdraw:
        let username = "withdrawuser"
        let password = "aKSmUtinsNfnfM"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic " + base64LoginString
        return ["Authorization": authString]
        }
    }
        
    var parameters: Parameters? {
    switch self {
    case .login (let email, let password):
        return ["username": email,
             "password": password]
    case .restorePassword (let email):
        return ["username": email]
    case .signup(let firstname, let currency, let emails, let password, let tenantId, let username):
        return ["firstName": firstname,
            "password": password,
            "currency":currency,
            "username":username,
            "emails": emails,
            "tenantId":tenantId]
    case .exchangeRate(let broker):
        return ["broker": broker]
    case .withdraw (let amount, let bankName, let beneficiaryBankAccount, let beneficiaryName, let accountNumber, let broker, let url, let billingServer, let currency, let name, let tenantId, let method):
        return ["amount" :amount,
                "bankName": bankName,
                "beneficiaryBankAccount": beneficiaryBankAccount,
                "beneficiaryName": beneficiaryName,
                "accountNumber": accountNumber,
                "broker": broker,
                "url": url,
                "billingServer": billingServer,
                "currency": currency,
                "name": name]
    case .logout, .billingHistory:
        return nil
    case .deposit(let amount, let currency, let accountNumber, let exchangeRate):
        return ["a": amount,
                "c": chinaUnionPaydefault,
                "a_n": accountNumber,
                "r_u": depositRedirectUrl,
                "e_r": exchangeRate,
                "a_c": currency]
        }
    }
        
    var method: httpMethod {
    switch self {
    case .login, .restorePassword, .signup, .deposit, .withdraw, .logout:
        return .post
    case .billingHistory,  .exchangeRate:
        return .get
        }
    }
}
