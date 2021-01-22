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
    func getAssetPrice(for assetId: Int64)
    func getAssetRange(leverage: Int64, timeDuration: Int64, type: String, assetId: Int64, stake: Int64)
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double)
    func getBanks()
}

let baseUrlString = "wss://stage.sunbeam-capital.com:8100/mt1/eventbus/websocket"

let sendPingJson: [String: Any] = ["type": "ping"]
let userInfoJson: [String: Any] = ["type": "send", "address": "client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let getBalanceJson: [String: Any] = ["type":"send", "address": "CurrentBalance", "headers": [String:String](), "body": ["currency": "%@"], "replyAddress": ""]
let readAllStatusesJson: [String: Any] = ["type":"send", "address": "ReadAllStatuses", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]
let banksJson: [String: Any] = ["type": "send", "address": "payapi.withdraw.china.banks", "headers": [String:String](), "body": [String:String](), "replyAddress": ""]

class WSManager: WebsocketAccess {
    static let shared = WSManager()
    var dataReceiver = DataReceiver()
    private var webSocketTask: URLSessionWebSocketTask?
    private let arrayOfAcceptors: [JsonAcception] = [UserJsonAcception(), BalanceJsonAcception(), BalanceHistoryJsonAcception(), PriceHistoryJsonAcception(), AssetsJsonAcception(), AssetPriceJsonAcception(), RangeJsonAcception(), OrderExecutorJSONAcception(), OrdersJsonAcception()]
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
    
    func register() {
        if let json = websocketJsonCreator.registerJSON(),
            let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }

    func getUserInfo() {
        if let messageString = Converter().jsonToString(json: userInfoJson) {
            send(messageString: messageString)
        }
    }
 
    func getBalance() {
        guard let user = dataReceiver.user else { return }
        guard let currency = user.currency else { return }
        if let messageString = Converter().jsonToString(json: getBalanceJson) {
            let messageStringWithFormat = String(format: messageString, currency)
            send(messageString: messageStringWithFormat)
        }
    }
    
    func getBalanceHistory() {
        guard let accountData = dataReceiver.accountData else { return }
        guard let from = accountData.timeIntervalFrom else { return }
        guard let to = accountData.timeIntervalTo else { return }
        let json = websocketJsonCreator.balanceiHistoryJSON(from: from, to: to)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
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
        let json = websocketJsonCreator.getPriceHistoryJSON(assetId: assetId)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func getAssetPrice(for assetId: Int64) {
        let json = websocketJsonCreator.getPriceJSON(assetId: assetId)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func getAssetRange(leverage: Int64, timeDuration: Int64, type: String, assetId: Int64, stake: Int64) {
        guard let user = dataReceiver.user else { return }
        guard let currency = user.currency else { return }
        guard let username = user.email else { return }
        let rangeId = generateVersionOneAkaTimeBasedUUID()
        let json = websocketJsonCreator.assetRange(rangeId: rangeId, leverage: leverage, timeDuration: timeDuration, type: type, currency: currency, assetId: assetId, stake: stake, username: username)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func getOrderHistoryForChart(assetId: Int64, minDate: Double) {
        guard let email = dataReceiver.user?.email else { return }
        let maxDate = Date().timeIntervalSince1970 * 1000
        let json = websocketJsonCreator.getOrdersHistoryJson(email: email, assetId: assetId, minDate: minDate, maxDate: maxDate)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double) {
        guard let user = dataReceiver.user else { return }
        guard let currency = user.currency else { return }
        let json = websocketJsonCreator.orderExecutor(leverage: leverage, rangeId: rangeId, min: min, max: max, currency: currency)
        if let messageString = Converter().jsonToString(json: json) {
            send(messageString: messageString)
        }
    }
    
    private func sendPing() {
        if let messageString = Converter().jsonToString(json: sendPingJson) {
            send(messageString: messageString)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if self.dataReceiver.connectionClosed == false {
                self.sendPing()
            }
        }
    }

   func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
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
