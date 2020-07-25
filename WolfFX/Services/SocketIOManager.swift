//
//  SocketIOManager.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import SocketIO

class SocketIOManager: NSObject {
     static let shared = SocketIOManager()
     private var manager: SocketManager?
     var socket: SocketIOClient!

    private override init() {
        let cookies = HTTPCookieStorage.shared.cookies!
        let url = URL(string: baseUrlString)!
        manager = SocketManager(socketURL: url, config: ["Set-Cookie" : cookies])
        socket = manager?.defaultSocket
    }
    
    func connectSocket() {
        socket.connect()
    }

    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false
    }
    
    func disconnectSocket(){
        socket.disconnect()
    }
}
