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
    case billingHistory
    case logout
    
    var path: String {
    switch self {
        case .login:
        return "/mt1/login"
    case .signup:
        return "/mt1/createUser"
    case .logout:
        return "/mt1/logout"
    case .billingHistory:
        return "/wolffx/billingHistory"
        }
    }
        
    var headers: Headers? {
    switch self {
    case .login, .signup, .billingHistory, .logout:
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
    case .logout, .billingHistory:
        return nil
        }
    }
        
    var method: httpMethod {
    switch self {
    case .login, .signup, .logout:
        return .post
    case .billingHistory:
        return .get
        }
    }
}
