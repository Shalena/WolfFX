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
                        let description = error.error.localizedDescription
                        let hsError = WolfError(description: description)
                        failure(hsError)
                }
            }
        default: return
        }
    }
}
    






















