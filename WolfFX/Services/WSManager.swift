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
    
    let webSocketTask = URLSession(configuration: .default).webSocketTask(with: URL(string: "wss://staging.cuboidlogic.com:8100/mt1/eventbus")!)

    public func connectToWebSocket() {
        webSocketTask.resume()
        self.receiveData() { _ in }
    }
    
    public func subscribeBtcUsd() {
        let message = URLSessionWebSocketTask.Message.string("client.trade.brokerName")
        webSocketTask.send(message) { error in
            if let error = error {
                print("WebSocket couldn’t send message because: \(error)")
            }
        }
    }

    public func unSubscribeBtcUsd() {
           let message = URLSessionWebSocketTask.Message.string("client.trade.brokerName")
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
                print("Received data: \(data)")
              @unknown default:
                debugPrint("Unknown message")
              }
              self.receiveData() {_ in }
        }
      }
        completion(self.dataArray)
    }
}
