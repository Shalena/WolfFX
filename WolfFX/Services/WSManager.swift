//
//  WSManager.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/16/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

protocol WebsocketAccess {
    func connect()
    func getUserInfo()
}

let baseUrlString = "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket"
let userInfoJson: [String: Any] = ["type":"send", "address":"client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress":""]

class WSManager: WebsocketAccess {
    var webSocketTask: URLSessionWebSocketTask?
    
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
