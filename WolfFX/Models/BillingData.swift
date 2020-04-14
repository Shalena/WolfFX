//
//  BillingData.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/12/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BillingData: NSObject {
    var balance: String?
    var bonus: String?
    var dateFrom: String?
    var amauntPendingWithdrawal: String?
    let dateTo: String?
    
    init (with balance: String?, bonus: String?, amauntPendingWithdrawal: String?, dateFrom: String?, dateTo: String?) {
        self.balance = balance
        self.bonus = bonus   
        self.amauntPendingWithdrawal = amauntPendingWithdrawal
        self.dateTo = dateTo
        self.dateFrom = dateFrom
    }
}
