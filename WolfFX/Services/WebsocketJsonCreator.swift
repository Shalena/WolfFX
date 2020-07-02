//
//  WebsocketJsonCreator.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class WebsocketJsonCreator {
    func assetRange(rangeId: String, leverage: Int64, timeDuration: Int64, type: String, currency: String, assetId: Int64, stake: Int64, username: String) -> [String : Any] {
        return ["type": "send",
                "address": "AssetRange",
                "headers": [:],
                "body" : ["rangeId": rangeId,
                          "timeDuration": timeDuration,
                          "leverage": leverage,
                          "type": type,
                          "assetId": assetId,
                          "stake":stake,
                          "currency": currency,
                          "username": username],
                "replyAddress": ""]
    }
    
    func orderExecutor(leverage: Int64, rangeId: String, min: Double, max: Double, currency: String) -> [String : Any] {
        let uuid = generateVersionOneAkaTimeBasedUUID()
        return ["type": "send",
        "address": "OrderExecutor",
        "headers": [:],
        "body" : ["range": [
                    "rangeId": rangeId,
                    "leverage": leverage,
                    "currency": currency,
                    "min": min,
                    "max":max]],
        "replyAddress": uuid]
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


