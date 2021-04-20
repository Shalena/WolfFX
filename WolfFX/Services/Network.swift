//
//  Network.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Networking

typealias JSON = [String : Any]
let depositPath = "/payapi/v1/praxis/payins"
let redirectUrlPath = "/wolffx/wallet/deposit"

enum BaseUrl: String {
    case prodEurope = "https://eu.sunbeam-capital.com"
    case stageEurope = "https://stage.sunbeam-capital.com"
}

protocol NetworkAccess {
  var baseUrl: String {get set}
  func login(email: String, password: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func restorePassword(email: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func getBillingHistory(success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void)
  func deposit(with amount: Double, currency: String, accountNumber: String, success: @escaping (String?) -> Void, failure: @escaping (WolfError?) -> Void)
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
    
    func restorePassword(email: String, success: @escaping (Bool) -> Void, failure: @escaping (WolfError?) -> Void) {
        performRequestSuccessfully(endpoint: Endpoint.restorePassword(email: email), success: { (successfully: Bool) in
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
    
    func deposit(with amount: Double, currency: String, accountNumber: String, success: @escaping (String?) -> Void, failure: @escaping (WolfError?) -> Void) {
        let depositUrl = baseUrl + depositPath
        guard var urlComponents = URLComponents(string: depositUrl) else { return }
        let session = URLSession(configuration: .default)
        let redirectUrl = baseUrl + redirectUrlPath
        urlComponents.queryItems = [
            URLQueryItem(name: "a", value: String(amount)),
            URLQueryItem(name: "c", value: currency),
            URLQueryItem(name: "a_n", value: accountNumber),
            URLQueryItem(name: "r_u", value: redirectUrl)]
       guard let url = urlComponents.url else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
       session.dataTask(with: request) { (data, response, error) in
       if let error = error {
            let description = error.localizedDescription
            let wolfError = WolfError.init(description: description)
            failure(wolfError)
       } else if
        let data = data {
        let webviewLink = String(data: data, encoding: .utf8)
        success(webviewLink)
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
        return BaseUrl.prodEurope.rawValue
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
        func performRequest(endpoint: Endpoint, success: @escaping (Data) -> Void, failure: @escaping (WolfError?) -> Void) {
        switch endpoint.method {
            case .post:
                networking.post(endpoint.path, parameterType: .custom("text/plain;charset=UTF-8"), parameters: endpoint.parameters) { result in
                    switch result {
                        case .success(let response):
                            print(response.headers)
                            success(response.data)
                        case .failure(let error):
                            print(error.fullResponse)
                            if error.statusCode == 200 {
                                
                            }
                            let description = error.error.localizedDescription
                            let hsError = WolfError(description: description)
                            failure(hsError)
                    }
                }
            case .get,.patch, .put:
            return
        }
    }
}
    






















