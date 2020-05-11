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
    func readAllStatuses()
    func getPriceHistory()
    func getAssetPrice()
    func getBanks()
    func ping()
}

let baseUrlString = "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket"
let userInfoJson: [String: Any] = ["type": "send", "address": "client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let getBalanceJson: [String: Any] = ["type":"send", "address": "CurrentBalance", "headers": [String:String](), "body": ["currency": "%@"], "replyAddress": ""]
let readAllStatusesJson: [String: Any] = ["type":"send", "address": "ReadAllStatuses", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let priceHistoryJson: [String: Any] = ["type":"send","address":"PriceHistoryRequests", "headers": [String:String](), "body": ["assetId": 9, "durationSec":300], "replyAddress": ""]
let assetPriceJson: [String: Any] = ["type": "register", "address": "AssetPrice-9-00000000-0000-0000-0000-000000000000", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let banksJson: [String: Any] = ["type": "send", "address": "payapi.withdraw.china.banks", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]

class WSManager: WebsocketAccess {
    static let shared = WSManager()
    var webSocketTask: URLSessionWebSocketTask?
    let arrayOfAcceptors: [JsonAcception] = [UserJsonAcception(), BalanceJsonAcception(), PriceHistoryJsonAcception(), AssetsJsonAcception(), AssetPriceJsonAcception()]
    var timer: Timer?

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
              self.connect()
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
        self.receiveData()
      }          
    }
    
    func getUserInfo() {
        if let messageString = Converter().jsonToString(json: userInfoJson) {
            send(messageString: messageString)
        }
    }
  
    func getBalance() {
        let user = DataReceiver.shared.user
        guard let currency = user?.currency else { return }
        if let messageString = Converter().jsonToString(json: getBalanceJson) {
            let messageStringWithFormat = String(format: messageString, currency)
            send(messageString: messageStringWithFormat)
        }
    }
    
    func getBanks() {
           if let messageString = Converter().jsonToString(json: banksJson) {
               send(messageString: messageString)
           }
       }
    
    func readAllStatuses() {
          if let messageString = Converter().jsonToString(json: readAllStatusesJson) {
              send(messageString: messageString)
          }
      }
    
    func getPriceHistory() {
        if let messageString = Converter().jsonToString(json: priceHistoryJson) {
            send(messageString: messageString)
        }
    }
    
    func getAssetPrice() {
        if let messageString = Converter().jsonToString(json: assetPriceJson) {
            send(messageString: messageString)
        }
    }
    
    func ping() {
        webSocketTask?.sendPing { (error) in
            if let error = error {
                print("Ping failed: \(error)")
            }
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
                self.ping()
            }
            timer.fire()
        }
    }
}
