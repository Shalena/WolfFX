//
//  Network.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Networking

typealias JSON = [String : Any]

enum BaseUrl: String {
    case prod = "https://wolffxwarrior.com"
    case stage = "https://staging.cuboidlogic.com"
    
}

protocol NetworkAccess {
  func login(email: String, password: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func getBillingHistory(success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func getExchangeRate(with broker: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func deposit(with amountFee: Double, success: @escaping (String) -> Void, failure: @escaping (WolfError?) -> Void) 
  func withdraw(amount: Double, beneficiaryBankAccount: String, beneficiaryName: String, accountNumber: String, broker: String, url : String, billingServer: String, tenantId: String, currency: String, name: String, method: String, bankName: String , success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func logout(success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
}

class NetwokManager: NetworkAccess {
   
    func signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)  {
        performRequestSuccessfully(endpoint: Endpoint.signup(firstname: firstname, currency: currency, emails: emails, password: password, tenantId: tenantId, username: username), success: { (successfully: Bool) in
            success (successfully)
        }, failure: { error in
            failure (error)
        })
    }
    
    func login(email: String, password: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
        performRequestSuccessfully(endpoint: Endpoint.login(email: email, password: password), success: { (successfully: Bool) in
            success (successfully)
        }, failure: { error in
            failure (error)
        })
    }
    
    func getBillingHistory(success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
        performRequestSuccessfully(endpoint: Endpoint.billingHistory, success: { (successfully: Bool) in
            success (successfully)
        }, failure: { error in
            failure (error)
        })
    }
    
    func getExchangeRate(with broker: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
        performRequestSuccessfully(endpoint: Endpoint.exchangeRate(broker: broker), success: { (successfully: Bool) in
            success (successfully)
        }, failure: { error in
            failure (error)
        })
    }
    
    func deposit(with amountFee: Double, success: @escaping (String) -> Void, failure: @escaping (WolfError?) -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://staging.cuboidlogic.com/payapi/v1/swiftpay/payins?a=10&c=CNY&a_n=2test@test.com&r_u=https://staging.cuboidlogic.com/wolffx/wallet/deposit&e_r=9.48930&a_c=GBP")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    if let content = String(data: data, encoding: .utf8) {
                        success(content)
                    }
                } catch {
                    let description = error.localizedDescription
                    let wolfError = WolfError(description: description)
                    failure(wolfError)
                }
            }
        }.resume()
    }
    
    func withdraw(amount: Double, beneficiaryBankAccount: String, beneficiaryName: String, accountNumber: String, broker: String, url: String, billingServer: String, tenantId: String, currency: String, name: String, method: String, bankName: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
        performRequestSuccessfully(endpoint: Endpoint.withdraw(amount: amount, bankName: bankName, beneficiaryBankAccount: beneficiaryBankAccount, beneficiaryName: beneficiaryName, accountNumber: accountNumber, broker: broker, url: url, billingServer: billingServer, currency: currency, name: name, tenantId: tenantId, method: method), success: { (successfully: Bool) in
                success (successfully)
            }, failure: { error in
                failure (error)
            })
       }
    
    func logout(success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)  {
           performRequestSuccessfully(endpoint: Endpoint.logout, success: { (successfully: Bool) in
               success (successfully)
           }, failure: { error in
               failure (error)
           })
       }
    
 lazy var networking: Networking = {
        let networking = Networking(baseURL: baseUrl)
        return networking
 }()
    
 lazy var hsDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
 }()
    
    lazy var baseUrl: String = {
        return BaseUrl.stage.rawValue
    }()
    
    lazy var payBaseUrl: String = {
          return "https://staging.cuboidlogic.com/payapi/v1/swiftpay/payins?a=10&c=CNY&a_n=2test@test.com&r_u=https://staging.cuboidlogic.com/wolffx/wallet/deposit&e_r=9.48930&a_c=GBP"
      }()
    
    func performRequestSuccessfully(endpoint: Endpoint, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
    networking.headerFields = endpoint.headers
    switch endpoint.method {
        case .post:
            networking.post(endpoint.path, parameters: endpoint.parameters) { result in
                switch result {
                    case .success(let response):
                        print(response.headers)
                        success(true)
                    case .failure(let error):
                        print(error.fullResponse)
                        let description = error.error.localizedDescription
                        let hsError = WolfError(description: description)
                        failure(hsError)
                }
            }
        case .get:
            networking.get(endpoint.path, parameters: endpoint.parameters) { result in
            switch result {
                case .success(let response):
                    print(response.headers)
                    if let json = try? response.data.toJSON() as? JSON {
                        let exchangeAcception = ExchangeRateJsonAcception()
                        exchangeAcception.accept(json: json)
                    }
                    success(true)
                case .failure(let error):
                    if error.statusCode == 200 {
                        success(true)
                    } else {
                        let description = error.error.localizedDescription
                        let hsError = WolfError(description: description)
                        failure(hsError)
                }
            }
        }
        case .patch, .put:
        return
    }
}
}
    






















