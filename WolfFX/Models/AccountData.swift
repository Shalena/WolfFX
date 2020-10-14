//
//  AccountData.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/12/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class AccountData: NSObject {
    var viewModel: AccountDataViewModel?
    var realBalanceHeaderString: String?
    var userCanPlay: Bool?
    var timeIntervalFrom: TimeInterval?
    var timeIntervalTo: TimeInterval?
    
    init (with viewModel: AccountDataViewModel?, realBalanceHeaderString: String?, userCanPlay: Bool?, timeIntervalFrom: Double?, timeIntervalTo: Double?) {
        self.viewModel = viewModel
        self.realBalanceHeaderString = realBalanceHeaderString
        self.userCanPlay = userCanPlay
        self.timeIntervalFrom = timeIntervalFrom
        self.timeIntervalTo = timeIntervalTo
    }
}

class AccountDataViewModel: NSObject {
    var balance: String?
    var realMoney: String?
    var bonus: String?
    var amauntPendingWithdrawal: String?
    var dateFrom: String?
    var dateTo: String?
    
    init (with balance: String?, realMoney: String?, bonus: String?, amauntPendingWithdrawal: String?, dateFrom: String?, dateTo: String?) {
        self.balance = balance
        self.realMoney = realMoney
        self.bonus = bonus
        self.amauntPendingWithdrawal = amauntPendingWithdrawal
        self.dateTo = dateTo
        self.dateFrom = dateFrom
    }
}
