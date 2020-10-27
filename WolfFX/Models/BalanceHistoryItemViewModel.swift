//
//  BalanceHistoryItemViewModel.swift
//  WolfFX
//
//  Created by Елена Острожинская on 10/13/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

enum TransactionStatus {
    case positive
    case negative
}

class BalanceHistoryItemViewModel: NSObject {
    var hoursMinutes: String?
    var calendarDay: String?
    var descriptionString: String?
    var transactionStatus: TransactionStatus?
    var amount: String?
    var balance: String?
    
    init (item: BalanceHistoryItem) {
        if let date = item.date {
            let pureDate = Date(timeIntervalSince1970: (date / 1000.0))
            let hoursMinutesDateFormatter = DateFormatter()
            hoursMinutesDateFormatter.dateFormat = "HH:mm"
            let hoursMinutesString = hoursMinutesDateFormatter.string(from: pureDate)
            self.hoursMinutes = hoursMinutesString            
            let calendarDayFormatter = DateFormatter()
            calendarDayFormatter.dateFormat = "dd-MMM-yyyy"
            let calendarDayString = calendarDayFormatter.string(from: pureDate)
            self.calendarDay = calendarDayString
        }
        var assetString: String?
        if let metadataString = item.metadata {
            let data = metadataString.data(using: .utf8)!
            let metadata = try? JSONDecoder().decode(Metadata.self, from: data)
            if let asset = metadata?.asset {
                assetString = asset
            }
        }
            self.descriptionString = (assetString ?? "") + " " + (item.transactionType ?? "")
        if item.transactionType == "WIN" || item.transactionType == "DEPOSIT" {
            self.transactionStatus = .positive
        } else if item.transactionType == "STAKE" || item.transactionType == "HOLD" {
            self.transactionStatus = .negative
        }
        if let amout = item.amount {
            let absoluteValue = abs(amout)
            self.amount = String(absoluteValue.truncate(places: 2))
        }
        if let balance = item.newBalance {
            self.balance = String(balance.truncate(places: 2))
        }
    }
}

struct CombinedBalanceHistoryItem {
    var date: Date
    var viewModel: BalanceHistoryItemViewModel
}
