//
//  TradeStatus.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/6/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum Status: String {
    case success = "SUCCESS"
    case error = "ERROR"
}

class TradeStatus: NSObject {
    var message: String?
    var success: Bool?
    
    init (message: String?, success: Bool?) {
        self.message = message
        self.success = success
    }
}
