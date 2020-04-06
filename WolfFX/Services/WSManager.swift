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
    let arrayOfAcceptors: [JsonAcception] = [UserJsonAcception(), BalanceJsonAcception()]
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
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let bodyDictionary = json["body"] as? [String: Any] {
                        print(bodyDictionary)
                        for acceptor in self.arrayOfAcceptors {
                            if acceptor.acceptJson(json: bodyDictionary) {
                                return
                            }
                        }
                    }
              @unknown default:
                debugPrint("Unknown message")
              }
        }
      }
    }
    
    func getUserInfo() {
        if let messageString = Converter().jsonToString(json: userInfoJson) {
            send(messageString: messageString)
        }
    }
  
    func getBalance() {
        if let messageString = Converter().jsonToString(json: getBalanceJson) {
            send(messageString: messageString)
        }
    }
}
