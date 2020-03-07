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
    case stage = "https://stage"
}

protocol NetworkAccess {
  func login(email: String, password: String, success: @escaping (User?) -> Void, failure: @escaping (WolfError?) -> Void)
}

class NetwokManager: NetworkAccess {
    
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
        return BaseUrl.prod.rawValue
    }()
    
//    lazy var baseUrl: String = {
//           #if Development
//           return BaseUrl.dev.rawValue
//           #elseif PreProd
//           return BaseUrl.preProd.rawValue
//           #elseif Release
//           return BaseUrl.prod.rawValue
//           #endif
//       }()
    
func perform<T: Codable>(endpoint: Endpoint, success: @escaping (T?) -> Void, failure: @escaping (WolfError?) -> Void) {
        networking.headerFields = endpoint.headers
        switch endpoint.method {
            case .get :
                networking.get(endpoint.path, parameters: endpoint.parameters) { result in
                    switch result {
                        case .success(let response):
                            let data = response.data
                            success(try? self.hsDecoder.decode(T.self, from: data))
                        case .failure(let error):
                            var hsError: WolfError?
                            if let errorDictionary: JSON = try! error.data.toJSON() as? JSON {
                                let description = errorDictionary["message"] as! String
                                 hsError = WolfError(description: description)
                            } else {
                                hsError = WolfError(description: error.error.localizedDescription)
                            }
                            failure(hsError)
                    }
                }
            case .post:
                networking.post(endpoint.path, parameters: endpoint.parameters) { result in
                    switch result {
                        case .success(let response):
                            let data = response.data
                            let user = try? self.hsDecoder.decode(T.self, from: data)
                            success(user)
                        case .failure(let error):
                            let description = error.error.localizedDescription
                            let hsError = WolfError(description: description)
                            failure(hsError)
                    }
            }
            case .patch:
                networking.patch(endpoint.path, parameters: endpoint.parameters) { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        let data = response.data
                        let mappableResponse = try? self.hsDecoder.decode(T.self, from: data)
                        success(mappableResponse)
                    case .failure(let error):
                        let errorDictionary: JSON = try! error.data.toJSON() as! JSON
                        let description = errorDictionary["message"] as! String
                        let hsError = WolfError(description: description)
                        failure(hsError)
                    }
                }
            case .put:
                networking.put(endpoint.path, parameters: endpoint.parameters) { result in
                    switch result {
                    case .success(let response):
                        let data = response.data
                        let mappableResponse = try? self.hsDecoder.decode(T.self, from: data)
                        success(mappableResponse)
                    case .failure(let error):
                        let errorDictionary: JSON = try! error.data.toJSON() as! JSON
                        let description = errorDictionary["message"] as! String
                        let hsError = WolfError(description: description)
                        failure(hsError)
                    }
                }
            }
        }
    
    func login(email: String, password: String, success: @escaping (User?) -> Void, failure: @escaping (WolfError?) -> Void)  {
        perform(endpoint: Endpoint.login(email: email, password: password), success: { (user: User?) in
            success (user)
        }, failure: { error in
            failure (error)
        })
    }
}
    
























