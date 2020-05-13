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
}



