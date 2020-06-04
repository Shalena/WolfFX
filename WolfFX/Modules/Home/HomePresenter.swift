//
//  HomePresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Charts

let currentType = "IN"  // In trade is implemented only
let leverageMultiplier: Int64 = 100
let investmentArray: [Int64] = [1, 5, 10, 20, 100]
let leverageArray: [Int64] = [2, 3, 4, 5]
let expiryTimeArray: [Int64] = [30, 60, 120, 900, 3600]
let expiryTimeTitlesArray = ["30s", "1m", "2m", "15m", "1h"]

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
    var tableDataSource: AssetsDataSource?
    var websocketManager: WebsocketAccess?
    var timer: Timer?
    var assetTimer: Timer?
    var currentRange: Range?
    var axisValueFormatter: IAxisValueFormatter?
    var axisLabels = [String]()
    
    let investmentDataSource: [PickerEntry] = {
        let currencySign: String = Currency(rawValue: DataReceiver.shared.user?.currency ?? "")?.sign ?? ""
        return investmentArray.map({ PickerEntry(title: String ($0) + currencySign , value: $0) })
    }()
    let leverageDataSource: [PickerEntry] = {
        return leverageArray.map({  PickerEntry(title: String($0) + "x", value: $0) })
    }()
    let expiryDataSource: [PickerEntry] = {
        var pickerEntries = [PickerEntry]()
        for (title, value) in zip(expiryTimeTitlesArray, expiryTimeArray) {
            let pickerEntry = PickerEntry.init(title: title, value: value)
            pickerEntries.append(pickerEntry)
        }
        return pickerEntries
    }()
    var selectedInvestment: PickerEntry?
    var selectedLeverage: PickerEntry?
    var selectedExpiry: PickerEntry?
    
    var selectedAsset: Asset? {
        didSet {
            if let title = selectedAsset?.name {
                view?.updateAssetButton(with: title)
            }
        }
    }
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
        self.dataReceiver = DataReceiver.shared
        self.websocketManager = WSManager.shared
        self.selectedInvestment = investmentDataSource.first
        self.selectedLeverage = leverageDataSource.first
        self.selectedExpiry = expiryDataSource.first
    }
    
    func setupLoginOverlay() {
        router?.setupLoginOverlay()
    }
    
    func homeViewIsReady() {
        self.websocketManager?.connect()
        self.websocketManager?.getBalance()
        observeAssets()
        observePriceHistory()
        observePrice()
        observeRange()
    }
    
    func tradeAction() {
        orderExecutor()
    }
       
    private func observeUser() {
        userObservation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
            self.view?.showHud()
            if change.newValue != nil {
                self.websocketManager?.getBalance()
            }
        }
    }
        
   private func observeAssets() {
    assetsObservation = observe(\.dataReceiver?.assets, options: [.old, .new]) { object, change in
        if let assets = change.newValue {
            self.assets = assets
            self.selectedAsset = assets?[0]
            let currencies = self.assets?.filter{$0.assetType == .currency}
            let indices = self.assets?.filter{$0.assetType == .indices}
            let commodities = self.assets?.filter{$0.assetType == .commodities}
            let sentiments = self.assets?.filter{$0.assetType == .sentiment}
            let grouppedAssets = [currencies, indices, commodities, sentiments]
            let dataSource = AssetsDataSource(grouppedAssets: grouppedAssets)
            self.tableDataSource = dataSource
            self.view?.updateAssetsTable()
            if let array = assets {
                if let asset = array.first(where: {$0.id == 13}) { // id 13 is for GPB/USD
                    self.selectedAsset = asset
                } else {
                
                }
            }
            self.getAssetRange()
            self.getPriceHistory()
        }
    }
}
    private func observePriceHistory() {
         priceHistoryObservation = observe(\.dataReceiver?.priceHistory, options: [.old, .new]) { object, change in
             if let priceEntries = change.newValue as? [PriceEntry] {
                self.axisLabels = priceEntries.map({$0.label})
                self.axisValueFormatter = IndexAxisValueFormatter(values: self.axisLabels)
                 DispatchQueue.main.async {
                     self.view?.updateChart(with: priceEntries)
                 }                 
                 self.getPrice()
             }
         }
     }
     
      private func observePrice() {
         priceObservation = observe(\.dataReceiver?.assetPrice, options: [.old, .new]) { object, change in
            self.view?.hideHud()
             if let assetPrice = change.newValue as? AssetPrice, let axisLabel = assetPrice.label {
                self.axisLabels.append(axisLabel)
                self.axisValueFormatter = IndexAxisValueFormatter(values: self.axisLabels)
                 DispatchQueue.main.async {
                    self.view?.updateChartWithNewValue(assetPrice: assetPrice)
                 }
             }
         }
     }
    
    private func getPriceHistory() {
        self.websocketManager?.getPriceHistory()
    }
    
    private func getPrice() {
        self.websocketManager?.connect()
              DispatchQueue.main.async {
                  self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [weak self]  (_) in                self?.websocketManager?.getAssetPrice()
                  })
              }
    }
  
    private func getAssetRange() {
        guard let leverageValue = selectedLeverage?.value else {return}
        let leverageParameter = leverageValue * leverageMultiplier
        guard let timeDuration = selectedExpiry?.value else {return}
        let type = currentType
        guard let assedId = selectedAsset?.id else {return}
        guard let stake = selectedInvestment?.value else {return}
        self.websocketManager?.connect()
        self.websocketManager?.getAssetRange(leverage: leverageParameter, timeDuration: timeDuration, type: type, assetId: assedId, stake: stake)
        DispatchQueue.main.async {
            self.assetTimer?.invalidate()
            self.assetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self]  (_) in
                self?.getAssetRange()
            })
        }
    }
    
    private func orderExecutor() {
        guard let leverageValue = selectedLeverage?.value else {return}
        let leverageParameter = leverageValue * leverageMultiplier
        guard let rangeId = currentRange?.rangeId else {return}
        guard let min = currentRange?.min else {return}
        guard let max = currentRange?.max else {return}
        self.websocketManager?.orderExecutor(leverage: leverageParameter, rangeId: rangeId, min: min, max: max)
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




