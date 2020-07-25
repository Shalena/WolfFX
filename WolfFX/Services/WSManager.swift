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
    func getPriceHistory(for assetId: Int64) 
    func getAssetPrice()
    func getAssetRange(leverage: Int64, timeDuration: Int64, type: String, assetId: Int64, stake: Int64)
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double)
    func getBanks()
}

let baseUrlString = "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket"
let sendPingJson: [String: Any] = ["type": "ping"]
let userInfoJson: [String: Any] = ["type": "send", "address": "client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let getBalanceJson: [String: Any] = ["type":"send", "address": "CurrentBalance", "headers": [String:String](), "body": ["currency": "%@"], "replyAddress": ""]
let readAllStatusesJson: [String: Any] = ["type":"send", "address": "ReadAllStatuses", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let assetPriceJson: [String: Any] = ["type": "register", "address": "AssetPrice-13-00000000-0000-0000-0000-000000000000", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let banksJson: [String: Any] = ["type": "send", "address": "payapi.withdraw.china.banks", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]

class WSManager: WebsocketAccess {
    static let shared = WSManager()
    private var webSocketTask: URLSessionWebSocketTask?
    private let arrayOfAcceptors: [JsonAcception] = [UserJsonAcception(), BalanceJsonAcception(), PriceHistoryJsonAcception(), AssetsJsonAcception(), AssetPriceJsonAcception(), RangeJsonAcception(), OrderExecutorJSONAcception()]
    private let websocketJsonCreator = WebsocketJsonCreator()
    private var timer: Timer?

    func connect() {
        stop()
        if let baseUrl = URL(string: baseUrlString) {
            webSocketTask = URLSession(configuration: .default).webSocketTask(with: baseUrl)
            webSocketTask?.resume()
            self.receiveData()
        }
        sendPing()
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
                                continue
                            }
                        }
                    }
              @unknown default:
              debugPrint("Unknown message")
            }
            self.receiveData()
        }
      }
    }
    
    func getUserInfo() {
        if let messageString = Converter().jsonToString(json: userInfoJson) {
            send(messageString: messageString)
        }
    }
 
    func getBalance() {
        let user = DataReceiver.shared?.user
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
    
    func getPriceHistory(for assetId: Int64) {
        let json = WebsocketJsonCreator().getPriceHistoryJSON(assetId: assetId)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func getAssetPrice() {
        if let messageString = Converter().jsonToString(json: assetPriceJson) {
            send(messageString: messageString)
        }
    }
    
    func getAssetRange(leverage: Int64, timeDuration: Int64, type: String, assetId: Int64, stake: Int64) {
        let user = DataReceiver.shared?.user
        guard let currency = user?.currency else { return }
        guard let username = DataReceiver.shared?.user?.email else { return }
        let rangeId = generateVersionOneAkaTimeBasedUUID()
        let json = websocketJsonCreator.assetRange(rangeId: rangeId, leverage: leverage, timeDuration: timeDuration, type: type, currency: currency, assetId: assetId, stake: stake, username: username)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double) {
        let user = DataReceiver.shared?.user
        guard let currency = user?.currency else { return }
        let json = websocketJsonCreator.orderExecutor(leverage: leverage, rangeId: rangeId, min: min, max: max, currency: currency)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
        
    private func sendPing() {
        if let messageString = Converter().jsonToString(json: sendPingJson) {
            send(messageString: messageString)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.sendPing()
        }
    }
    
   func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    

   private func generateVersionOneAkaTimeBasedUUID() -> String {
        // figure out the sizes

        let uuidSize = MemoryLayout<uuid_t>.size
        let uuidStringSize = MemoryLayout<uuid_string_t>.size

        // get some ram

        let uuidPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: uuidSize)
        let uuidStringPointer = UnsafeMutablePointer<Int8>.allocate(capacity: uuidStringSize)

        // do the work in C

        uuid_generate_time(uuidPointer)
        uuid_unparse(uuidPointer, uuidStringPointer)

        // make a Swift string while we still have the C stuff

       let uuidString = NSString(utf8String: uuidStringPointer) as String?

        // avoid leaks

        assert(uuidString != nil, "uuid (V1 style) failed")
        return uuidString ?? ""
    }    
}
