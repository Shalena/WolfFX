//
//  LoginPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/2/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Starscream

class LoginPresenter: LoginEvents, WebSocketDelegate {
    
    
    var view: LoginViewProtocol?
    var router: LoginTransitions?
    var networkManager: NetworkAccess
    var webSocketTask: URLSessionWebSocketTask?
    var socket: WebSocket?
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
    }
    
    func signIn(email: String, password: String) {
                networkManager.login(email: email, password: password, success: { (successfully: Bool) in
                    if successfully {
                        self.startWebsocket()
                    }
                }, failure: { [weak self] error in
                    if let error = error {
                      self?.view?.showErrorAlertWith(error: error)
                    }
                })
    }
    
    func startWebsocket() {
 //             WSManager.shared.connectToWebSocket()
 //             WSManager.shared.subscribeBtcUsd()
 //             self.getData()
        let url = URL(string: "wss://staging.cuboidlogic.com:8100/mt1/eventbus/websocket")!
        var request = URLRequest(url: url)
        let json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        socket = WebSocket(request: request, certPinner: nil, compressionHandler:nil)
        socket?.delegate = self
        socket?.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        checkResponse(event: event)
    }
    
    private func checkResponse(event: WebSocketEvent) {
        switch event {
        case .connected(let responseJson):
            print(responseJson)
            let userInfoJson: [String: Any] = ["address":"client.trade.userInfo"]
            if let string = jsonToString(json: userInfoJson) {
                socket?.write(string: string, completion: {
                    
                })
            }
//            if let userInfoData = try? JSONSerialization.data(withJSONObject: userInfoJson) {
//               // socket?.write(data: userInfoData)
//                socket?.write(ping: userInfoData)
//            }
//            
        case .error(let error):
            print(error)
            if let description = error?.localizedDescription {
                print(description)
                let wolfError = WolfError.init(description: description)
                view?.showErrorAlertWith(error: wolfError)
                
            }
        case .cancelled:
            print(event)
        default:
            return
        }
    }
    
    func signUpPressed () {
        router?.signUpPressed ()
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
