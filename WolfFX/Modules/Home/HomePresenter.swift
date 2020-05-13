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
    var userObservation: NSKeyValueObservation?
    var assetsObservation: NSKeyValueObservation?
    var priceHistoryObservation: NSKeyValueObservation?
    var priceObservation: NSKeyValueObservation?
    var rangeObservation: NSKeyValueObservation?
    var assets: [Asset]?
    var selectedAsset: Asset?
    var tableDataSource: AssetsDataSource?
    var websocketManager: WebsocketAccess?
    var timer: Timer?
    var currentRange: Range?
    
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
        observeUser()
        observeAssets()
        observePriceHistory()
        observePrice()
        observeRange()
    }
    
    func tradeAction() {
        
    }
    
    private func observeUser() {
        userObservation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
            if change.newValue != nil {
                self.websocketManager?.connect()
                self.websocketManager?.getBalance()
            }
        }
    }
        
   private func observeAssets() {
    assetsObservation = observe(\.dataReceiver?.assets, options: [.old, .new]) { object, change in
        if let assets = change.newValue {
            self.assets = assets
            let currencies = self.assets?.filter{$0.assetType == .currency}
            let indices = self.assets?.filter{$0.assetType == .indices}
            let commodities = self.assets?.filter{$0.assetType == .commodities}
            let sentiments = self.assets?.filter{$0.assetType == .sentiment}
            let grouppedAssets = [currencies, indices, commodities, sentiments]
            let dataSource = AssetsDataSource(grouppedAssets: grouppedAssets)
            self.tableDataSource = dataSource
            self.view?.updateAssetsTable()
            self.websocketManager?.connect()
            self.websocketManager?.getAssetRange()
          //  self.getPriceHistory()
        }
    }
}

    private func getPriceHistory() {
        self.websocketManager?.connect()
        self.websocketManager?.getPriceHistory()
    }
    
    private func getPrice() {
        self.websocketManager?.connect()
        self.websocketManager?.getAssetPrice()
    }
    
    private func observePriceHistory() {
        priceHistoryObservation = observe(\.dataReceiver?.priceHistory, options: [.old, .new]) { object, change in
            if let priceEntries = change.newValue as? [PriceEntry] {
                DispatchQueue.main.async {
                    self.view?.updateChart(with: priceEntries)
                }
                self.getPrice()
            }
        }
    }
    
     private func observePrice() {
        priceObservation = observe(\.dataReceiver?.assetPrice, options: [.old, .new]) { object, change in
            if let assetPrice = change.newValue as? AssetPrice {
                DispatchQueue.main.async {
                   self.view?.updateChartWithNewValue(assetPrice: assetPrice)
                }
                self.getPrice()
            }
        }
    }
    
    private func observeRange() {
        rangeObservation = observe(\.dataReceiver?.range, options: [.old, .new]) { object, change in
            if let range = change.newValue as? Range {
                self.currentRange = range
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
    
    func update(cell: AssetCell, with text: String) {
        cell.titleLabel.text = text
    }
}

struct PickerEntry {
    var title: String
    var value: Int
}

