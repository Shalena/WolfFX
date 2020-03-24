//
//  WSManager.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/16/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class WSManager {
    public static let shared = WSManager() 
    private init(){}
    
    private var dataArray = [String]()
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket")!)

    public func connectToWebSocket() {
        webSocketTask.resume()
        self.receiveData() { _ in }
    }
    
    public func subscribeBtcUsd() {

        let userInfoJson: [String: Any] = ["type":"send", "address":"client.trade.userInfo", "headers": [String:String](), "body": [String:String](), "replyAddress":""]
        print(userInfoJson)
        guard let string = jsonToString(json: userInfoJson) else {return}
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }

    public func unSubscribeBtcUsd() {
           let message = URLSessionWebSocketTask.Message.string("client.trade.userInfo")
           webSocketTask.send(message) { error in
               if let error = error {
                   print("WebSocket couldn’t send message because: \(error)")
               }
           }
       }
    
    func receiveData(completion: @escaping ([String]?) -> Void) {
      webSocketTask.receive { result in
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
              self.receiveData() {_ in }
        }
      }
        completion(self.dataArray)
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
