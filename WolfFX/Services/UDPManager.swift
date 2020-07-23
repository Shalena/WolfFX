//
//  UDPManager.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/15/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//


import Foundation
import CocoaAsyncSocket

class UDPManager: NSObject, GCDAsyncSocketDelegate{
    let host = "https://staging.cuboidlogic.com:8100/mt1/eventbus"
    let port:UInt16 = 8100

    let cmdDeviceInformation = "?0600\r";
    let cmdDeviceIStandByeExit = "?060B\r";
    let cmdDeviceIStandByeEnter = "?060A\r";
    var socket: GCDAsyncSocket!

    override init() {
       
        super.init()
        print("Started wifi scanning!\n")

        socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        do {
            try socket.connect(toHost: host, onPort: port)
        } catch let error {
            print(error)
        }
        print("Connecting to instrument...!\n")
    }

    public func socket(_ socket: GCDAsyncSocket, didConnectToHost host: String, port p:UInt16){
        print("didConnectToHost!\n")
        let data = cmdDeviceIStandByeEnter.data(using: .utf8)
        print("TX: ", terminator: " ")
        print(data! as NSData)
        socket.write(data!, withTimeout:10, tag: 0)
        socket.readData(withTimeout: -1, tag: 0) //This line was missing!
    }

    public func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("didWriteData");
    }

    public func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("didReceiveData")
        let rxData:Data = Data()
        socket.readData(to: rxData, withTimeout: 5, buffer: nil, bufferOffset: 0, tag: 0)
        print("RX: ", terminator: " ")
        print(rxData as NSData)
    }

    public func socket(_ sock: GCDAsyncSocket, didRead: Data, withTag tag:CLong){
        print("didRead!");
    }

    public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("didDisconnect!")
    }
}
