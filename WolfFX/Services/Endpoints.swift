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
    
    var path: String {
    switch self {
        case .login:
        return "pathTologin"
        }
    }
        
    var headers: Headers? {
    switch self {
        case .login:
        return nil
        }
    }
        
    var parameters: Parameters? {
    switch self {
        case .login (let email, let password):
        return ["email": email,
             "password": password]
        }
    }
        
    var method: httpMethod {
    switch self {
    case .login:
        return .post
        }
    }
}
