//
//  Endpoints.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/29/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

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
    case signup(firstname: String, currency: String, emails: [String], password: String, tenantId: String, username: String)
    
    var path: String {
    switch self {
        case .login:
        return "/mt1/login"
    case .signup:
        return "/mt1/createUser"
        }
    }
        
    var headers: Headers? {
    switch self {
    case .login, .signup:
        return nil
        }
    }
        
    var parameters: Parameters? {
    switch self {
        case .login (let email, let password):
        return ["username": email,
             "password": password]
    case .signup(let firstname, let currency, let emails, let password, let tenantId, let username):
        return ["firstName": firstname,
            "password": password,
            "currency":currency,
            "username":username,
            "emails": emails,
            "tenantId":tenantId]
        }
    }
        
    var method: httpMethod {
    switch self {
    case .login, .signup:
        return .post
        }
    }
}
