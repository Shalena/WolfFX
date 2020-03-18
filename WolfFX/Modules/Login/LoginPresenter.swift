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
    //    let json: [String: Any] = ["type":"send", "address":"client.trade.userInfo"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        socket = WebSocket(request: request, certPinner: nil, compressionHandler:nil)
        socket?.delegate = self
        socket?.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
//        socket?.write(string: "client.trade.userInfo", completion: {
//            
//        })
    }
    
    private func getData() {
         WSManager.shared.receiveData() { [weak self] (data) in
                        
         }
     }
    
    func signUpPressed () {
        router?.signUpPressed ()
    }
}
