//
//  Converter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/3/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Charts

class Converter {
     private func realBalanceHeaderString(from realMoney: Double?, currencyString: String?, bonus: Double?) -> String {
        var currencySign = ""
        var realMoneyPart: Double = 0.00
        var bonusPart: Double = 0.00
        
        if let realMoney = realMoney {
            realMoneyPart = realMoney
        }
        
        if let bonus = bonus {
            bonusPart = bonus
        }
        
        if let currency = currencyString, let sign = Currency(rawValue: currency)?.sign {
            currencySign = sign
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        let realBalance = realMoneyPart + bonusPart
        let realBalanceString =  formatter.string(from: NSNumber(value: realBalance.truncate(places: 2))) ?? ""
        let resultString = [currencySign, realBalanceString].joined(separator: " ")
        return resultString
    }
    
    func accountData(from realMoney: Double?, bonus: Double?, amauntPendingWithdraw: Double?, dateTo: TimeInterval?, currencyString: String?) -> AccountData {
        var realMoneyString = "0.0"
        var bonusString = "0.0"
        var amauntPendingWithdrawString = "0.0"
        var dateFromString = ""
        var dateToString = ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
 
        if let realMoney = realMoney {
            realMoneyString = formatter.string(from: (NSNumber(value: realMoney.truncate(places: 2)))) ?? ""
        }
        
        if let bonus = bonus {
            bonusString = formatter.string(from: (NSNumber(value: bonus.truncate(places: 2)))) ?? ""
        }
        
        if let amauntPendingWithdraw = amauntPendingWithdraw {
            amauntPendingWithdrawString = formatter.string(from: (NSNumber(value: amauntPendingWithdraw.truncate(places: 2)))) ?? ""
        }
        
        var timeIntervalFrom: Double?
        var timeIntervalTo: Double?
        
        if let time = dateTo {
            timeIntervalTo = time / 1000.0
            let date = Date(timeIntervalSince1970: (timeIntervalTo!))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMM/yyyy"
            dateToString = dateFormatter.string(from: date)
            let dateFrom = date.startOfMonth()
            timeIntervalFrom = dateFrom.timeIntervalSince1970
            dateFromString = dateFormatter.string(from: dateFrom)
        }
        
        let balanceHeaderString = realBalanceHeaderString(from: realMoney, currencyString: currencyString, bonus: bonus)
        let viewModel = AccountDataViewModel(with: balanceHeaderString, realMoney: realMoneyString, bonus: bonusString, amauntPendingWithdrawal: amauntPendingWithdrawString, dateFrom: dateFromString, dateTo: dateToString)
        let userCanPlay: Bool?
        if let realMoney = realMoney,
            let bonusMoney = bonus,
            realMoney > 0.0 || bonusMoney > 0.0 {
            userCanPlay = true
        } else {
            userCanPlay = false
        }        
        let accountData = AccountData(with: viewModel, realBalanceHeaderString: balanceHeaderString, userCanPlay: userCanPlay, timeIntervalFrom: timeIntervalFrom! * 1000, timeIntervalTo: dateTo)
        
        return accountData
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
    
    func maxString(from max: Double) -> String {
        let valueString = String(format: "%g", max)
        return [R.string.localizable.max().localized(), valueString].joined(separator: " ")
    }
    
    func minString(from min: Double) -> String {
        let valueString = String(format:"%g", min)
        return [R.string.localizable.min().localized(), valueString].joined(separator: " ")
    }
    
    func shapshotsFrom(orders: [Order], initialTime: Double) -> [Snapshot] {
        let initialValue = initialTime * 1000 // server returns time in miliseconds, in the chart it was already /1000
        var filtered = [Order]()
        for order in orders {
            if let startTime = order.startTime {
                if startTime >= initialValue {
                    filtered.append(order)
                }
            }
        }
        var shapshots = [Snapshot]()
        for order in filtered {
            if let startTime = order.startTime,
               let max = order.upperBound,
               let min = order.lowerBound,
               let expiryTime = order.expiryTime,
               let status = order.status,
               let orderId = order.orderId {
               let duration = Int64((expiryTime - startTime) / 1000)
               let startTimeInSeconds = startTime / 1000
               let isSuccess = order.payOut != 0.0
                let view = SnapshotView()
                let snapshot = Snapshot(startTime: startTimeInSeconds, max: max, min: min, width: 0.0, duration: duration, orderStatus: OrderStatus(rawValue: status) ?? .expired, isSuccess: isSuccess, orderId: orderId)
                snapshot.view = view
              shapshots.append(snapshot)
            }
        }
        return shapshots
    }
    
    func shapshotFrom(order: Order) -> Snapshot? {
        var snapshot: Snapshot?
        if let startTime = order.startTime,
        let max = order.upperBound,
        let min = order.lowerBound,
        let expiryTime = order.expiryTime,
        let status = order.status,
        let orderId = order.orderId {
        let duration = Int64((expiryTime - startTime) / 1000)
        let startTimeInSeconds = startTime / 1000
        let isSuccess = order.payOut != 0.0
        let view = SnapshotView()
        snapshot = Snapshot(startTime: startTimeInSeconds, max: max, min: min, width: 0.0, duration: duration, orderStatus: OrderStatus(rawValue: status) ?? .expired, isSuccess: isSuccess, orderId: orderId)
            snapshot?.view = view
        }
        return snapshot
    }
    
}

