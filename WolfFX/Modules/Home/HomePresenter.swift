//
//  HomePresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Charts

let investmentArray: [Int] = [1, 5, 10, 20, 100]
let leverageArray: [Int] = [2, 3, 4, 5]
let expiryTimeArray = ["30s", "1m", "2m", "15m", "1h"]

class HomePresenter: NSObject, HomeEvents {
    var view: HomeViewProtocol?
    var router: HomeTransitions?
    var networkManager: NetworkAccess
    @objc dynamic var dataReceiver: DataReceiver?
    var observation: NSKeyValueObservation?
    var assets: [Asset]?
    var tableDataSource: [[Asset]]?
    var websocketManager: WebsocketAccess?
    var timer: Timer?
    
    let investmentDataSource: [PickerEntry] = {
        let currencySign: String = Currency(rawValue: DataReceiver.shared.user?.currency ?? "")?.sign ?? ""
        return investmentArray.map({ PickerEntry(title: String ($0) + currencySign , value: $0) })
    }()
    let leverageDataSource: [PickerEntry] = {
        return leverageArray.map({  PickerEntry(title: String($0) + "x", value: $0) })
    }()
    let expiryDataSource = expiryTimeArray
    
    var selectedInvestment: PickerEntry? = {
        if let middleElement = investmentArray.middle, let currency = DataReceiver.shared.user?.currency {
            let currencySign: String = Currency(rawValue: currency)?.sign ?? ""
            return PickerEntry(title: String(middleElement) + currencySign, value: middleElement)
    } else {
            return nil
        }
    }()
    var selectedLeverage: PickerEntry? = {
        if let middleElement = leverageArray.middle {
            return PickerEntry(title: String(middleElement) + "x", value: middleElement)
        } else {
            return nil
        }
    }()
    var selectedExpiry: String? = {
        return expiryTimeArray.middle
    }()
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
        self.dataReceiver = DataReceiver.shared
        self.websocketManager = WSManager.shared
    }
    
    func setupLoginOverlay() {
        router?.setupLoginOverlay()
    }
    
    func homeViewIsReady() {
        observe()
        websocketManager?.readAllStatuses()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.websocketManager?.getAssetPrice()
        }
    }
    
    func observe() {
    observation = observe(\.dataReceiver?.assets, options: [.old, .new]) { object, change in
        if let assets = change.newValue {
            self.assets = assets
            let currencies = self.assets?.filter{$0.assetType == .currency}
            let indices = self.assets?.filter{$0.assetType == .indices}
            let commodities = self.assets?.filter{$0.assetType == .commodities}
            let sentiments = self.assets?.filter{$0.assetType == .sentiment}
            
      
        }
    }
}
    
    func textForInfoLabel() -> String? {
        if let investment = selectedInvestment, let leverage = selectedLeverage {
            let product: Double = Double(investment.value * leverage.value)
            let text = leverage.title + "\n" + String(product)
            return text
        } else {
          return nil
        }
    }
}

struct PickerEntry {
    var title: String
    var value: Int
}

struct WEntry {
    var value: Double
    var date: Date
    var label: String
    
    init(value: Double,
          date: Date) {
        self.value = value
        self.date = date
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let label = formatter.string(from: date)
        self.label = label
       }
    
  static func wEntriesArray() -> [WEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let firstDate = formatter.date(from: "2016/10/08 22:31")!
        let secondDate = formatter.date(from: "2016/10/08 22:32")!
        let thirdDate = formatter.date(from: "2016/10/08 22:33")!
        let fourthDate = formatter.date(from: "2016/10/08 22:34")!
        let fifthDate = formatter.date(from: "2016/10/08 22:35")!
        let wEntriesArray = [
            WEntry(value: 3.0, date: firstDate),
            WEntry(value: 10.0, date: secondDate),
            WEntry(value: 1.0, date: thirdDate),
            WEntry(value: 8.0, date: fourthDate),
            WEntry(value: 7.0, date: fifthDate)
        ]
        return wEntriesArray
    }
}
