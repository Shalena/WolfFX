//
//  WSManager.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/16/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum VertxResponseKeys: String {
    case profile = "profile"
    case username = "username"
    case balance = "balance"
    case currency = "currency"
    case bonus = "bonus"
}

protocol WebsocketAccess {
    func connect()
    func getUserInfo()
    func getBalance()
}

let baseUrlString = "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket"
let userInfoJson: [String: Any] = ["type":"send", "address":"client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress":""]
let getBalanceJson: [String: Any] = ["type":"send", "address": "CurrentBalance", "headers": [String:String](), "body": ["currency":"GBP"], "replyAddress":""]


class WSManager: WebsocketAccess {
    static let shared = WSManager()
    var webSocketTask: URLSessionWebSocketTask?
    var dataReceiver: DataReceiver?

    lazy var decoder: JSONDecoder = {
           let decoder = JSONDecoder()
           decoder.keyDecodingStrategy = .convertFromSnakeCase
           return decoder
    }()

    func connect() {
        if let baseUrl = URL(string: baseUrlString) {
            webSocketTask = URLSession(configuration: .default).webSocketTask(with: baseUrl)
            webSocketTask?.resume()
            self.receiveData()
        }
    }
    
    func send(messageString: String) {
        let messageTask = URLSessionWebSocketTask.Message.string(messageString)
        webSocketTask?.send(messageTask) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }

    func receiveData() {
      webSocketTask?.receive { result in
        switch result {
            case .failure(let error):
              print("Error in receiving message: \(error)")
            case .success(let message):
              switch message {
              case .string(let text):
                print(text)
                case .data(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        print(json)
                        self.check(json: json)
                    }
              @unknown default:
                debugPrint("Unknown message")
              }
        }
      }
    }
    
    func getUserInfo() {
        if let messageString = jsonToString(json: userInfoJson) {
            send(messageString: messageString)
        }
    }
  
    func getBalance() {
        if let messageString = jsonToString(json: getBalanceJson) {
            send(messageString: messageString)
        }
    }
    
    func check(json: JSON) {
        if let bodyDictionary = json["body"] as? [String: Any] {
            let keys: [String] = bodyDictionary.map({ $0.key })
            print(keys)
            var balance: Double?
            var currency: String?
            var bonus: Double?
            for key in keys {
                let vertxResponseKey = VertxResponseKeys(rawValue: key)
                switch vertxResponseKey {
                    case .profile:
                        if let userjson = bodyDictionary[VertxResponseKeys.profile.rawValue] as? JSON {
                            let userjsonstring = jsonToString(json: userjson)
                            if let jsonData = userjsonstring?.data(using: .utf8){
                                if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
                                    print(user)
                                    dataReceiver?.user = user
                                }                               
                            }
                        }
                    case .username:
                        print(bodyDictionary[key])
                    case .balance:
                        balance = bodyDictionary[key] as? Double
                    case .currency:
                        currency = bodyDictionary[key] as? String
                    case .bonus:
                        balance = bodyDictionary[key] as? Double
                case .none:
                    continue
                }
            }
            let realBalanceString = Converter().realBalance(from: balance, currencyString: currency, bonus: bonus)
            dataReceiver?.realBalance = realBalanceString
            
        }
    }
    
    func jsonToString(json: JSON) -> String? {
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return (convertedString) // <-- here is ur string

        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }

}
