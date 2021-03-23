//
//  HomePresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import Charts

struct Credentials {
    let loginEmail: String
    let password: String
}

let currentType = "IN"  // In trade is implemented only for the first version of the app
let leverageMultiplier: Int64 = 100
let investmentArray: [Int64] = [1, 5, 10, 20, 100]
let leverageArray: [Int64] = [2, 3, 4, 5]
let expiryTimeArray: [Int64] = [30, 60, 120, 900, 3600]

class HomePresenter: NSObject, HomeEvents {
    var view: HomeViewProtocol?
    var router: HomeTransitions?
    var networkManager: NetworkAccess
    @objc dynamic var dataReceiver: DataReceiver?
    var userCanPlay = false
    var shouldPerformHTTPLogin = false
    var shouldShowHowToTrade = true
    var credentials: Credentials?
    var connectionObservation: NSKeyValueObservation?
    var userObservation: NSKeyValueObservation?
    var accountDataObservation: NSKeyValueObservation?
    var assetsObservation: NSKeyValueObservation?
    var priceHistoryObservation: NSKeyValueObservation?
    var priceObservation: NSKeyValueObservation?
    var rangeObservation: NSKeyValueObservation?
    var tradeStatusObservation: NSKeyValueObservation?
    var ordersObservation: NSKeyValueObservation?
    var newSnapshotObservation: NSKeyValueObservation?
    var languageObservation: NSKeyValueObservation?
    var assets: [Asset]?
    var expiryDataSource: [PickerEntry]?
    var tableDataSource: AssetsDataSource?
    var priceTimer: Timer?
    var assetTimer: Timer?
    var currentRange: Range?
    var axisLabels = [String]()
    let converter = Converter()
    
    var investmentDataSource: [PickerEntry] {
        get {
            let currencySign: String = Currency(rawValue: WSManager.shared.dataReceiver.user?.currency ?? "")?.sign ?? ""
            return investmentArray.map({ PickerEntry(title: String ($0) + currencySign , value: $0) })
        }
    }
    let leverageDataSource: [PickerEntry] = {
        return leverageArray.map({  PickerEntry(title: String($0) + "x", value: $0) })
    }()
  
    var selectedInvestment: PickerEntry? {
        didSet {
             DispatchQueue.main.async {
                self.view?.updatePickersTextFields()
            }
        }
    }
    var selectedLeverage: PickerEntry?
    var selectedExpiry: PickerEntry?
    
    var selectedAsset: Asset? {
        didSet {
            if selectedAsset?.id != oldValue?.id {     // TODO: needs refactor
                if let title = selectedAsset?.name {
                    view?.updateAssetButton(with: title)
                }
                WSManager.shared.dataReceiver.selectedAsset = selectedAsset
                stopPriceTimer()
                stopAsserRangeTimer()
                view?.showHud()
                getPriceHistory()
                getAssetRange()
            }
        }
    }
    
    init (with networkManager: NetworkAccess) {
        self.networkManager = networkManager
        self.dataReceiver = WSManager.shared.dataReceiver
    }
    
    func homeViewIsReady() {
        expiryDataSource = createExpiryDataSource() // this method should be called before setupSelectedValues, call it every time after changing the language
        setupSelectedValues()
        observeUser()
        observeAccountData()
        observeAssets()
        observePriceHistory()
        observePrice()
        observeRange()
        observeTradeStatus()
        observeOrders()
        observeNewSnapshot()
        observeLanguage()
        
        if shouldPerformHTTPLogin {
          performHTTPLogin()
        } else {
            performWebsocketLogin()
        }
    }
    
    func tradeAction() {
        if userCanPlay {
            orderExecutor()            
        } else {
            router?.goToDeposit()
        }
    }
    
    func maxForSnapshot() -> Double? {
        return currentRange?.max
    }
    
    func minForSnapshot() -> Double? {
        return currentRange?.min
    }
    
    private func setupSelectedValues() {
        self.selectedInvestment = investmentDataSource.first
        self.selectedLeverage = leverageDataSource.first
        self.selectedExpiry = expiryDataSource?.first
    }
    
    func createExpiryDataSource() -> [PickerEntry]? {
          var pickerEntries = [PickerEntry]()
        //The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
        let thirtySeconds = R.string.localizable.seconds("30").localized()
        let oneMinute = R.string.localizable.minutes("1").localized()
        let twoMinutes = R.string.localizable.minutes("2").localized()
        let fifteenMinutes = R.string.localizable.minutes("15").localized()
        let oneHour = R.string.localizable.hours("1").localized()
        let titlesArray = [thirtySeconds, oneMinute, twoMinutes, fifteenMinutes, oneHour]
          for (title, value) in zip(titlesArray, expiryTimeArray) {
              let pickerEntry = PickerEntry(title: title, value: value)
              pickerEntries.append(pickerEntry)
          }
          return pickerEntries
    }
    
    private func performHTTPLogin() {
        if let credentials = credentials {
            view?.showHud()
            networkManager.login(email: "stage-test@test.com", password: "q12345678!", success: { (successfully: Bool) in
                if successfully {
                    self.performWebsocketLogin()
                } else {
                    self.router?.loginFailed()
                }
            }, failure: { [weak self] error in
                self?.view?.hideHud()
                if let error = error {
                    self?.view?.showErrorAlertWith(error: error)
                    self?.router?.loginFailed()
                }
            })
        }
    }
    
    private func performWebsocketLogin() {
        WSManager.shared.dataReceiver.connectionClosed = false
        WSManager.shared.connect()     
        WSManager.shared.getUserInfo()
    }
    
    func observeLanguage() {
    languageObservation = observe(\.dataReceiver?.language, options: [.old, .new]) { object, change in
               if (change.newValue as? String) != nil {
                   self.expiryDataSource = self.createExpiryDataSource()
                   self.view?.localize()
               }
           }
    }
    
    private func observeUser() {
        userObservation = observe(\.dataReceiver?.user, options: [.old, .new]) { object, change in
               if change.newValue != nil {
                 self.selectedInvestment = self.investmentDataSource.first
                 self.router?.userHadSuccessfullyLoggedIn()
                 self.view?.reloadInvestmentPicker() // because we should show currency sign in it
                 WSManager.shared.getBalance()
               }
           }
       }
    
    private func observeAccountData() {
        accountDataObservation = observe(\.dataReceiver?.accountData, options: [.old, .new]) { object, change in
            if let accountData = change.newValue as? AccountData,
                let userCanPlay = accountData.userCanPlay {
                DispatchQueue.main.async {
                    self.userCanPlay = userCanPlay
                    self.view?.setupPlayButtonDesign()
                }
            }
            WSManager.shared.readAllStatuses()
        }
    }

    private func observeTradeStatus() {
        tradeStatusObservation = observe(\.dataReceiver?.tradeStatus, options: [.old, .new]) { object, change in
            if let tradeStatus = change.newValue, let message = tradeStatus?.message {
                DispatchQueue.main.async {                   
                    self.view?.showPopup(title: nil, message: message, time: 5)
                }
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
            if let array = assets {
                if let asset = array.first(where: {$0.id == 13}) { // id 13 is for GPB/USD
                    self.selectedAsset = asset
                } else {
                
                }
            }
            self.getAssetRange()
        }
    }
}
    private func observePriceHistory() {
         priceHistoryObservation = observe(\.dataReceiver?.priceHistory, options: [.old, .new]) { object, change in
             if let priceEntries = change.newValue as? [PriceEntry] {
                 DispatchQueue.main.async {
                     self.view?.updateChart(with: priceEntries)
                }             
                self.getPrice()
                let minDate = priceEntries[0].timesTemp
                if let id = self.selectedAsset?.id {
                    WSManager.shared.getOrderHistoryForChart(assetId: id, minDate: minDate)
                }
             }
         }
     }
     
      private func observePrice() {
         priceObservation = observe(\.dataReceiver?.assetPrice, options: [.old, .new]) { object, change in
             if let assetPrice = change.newValue as? AssetPrice {
                 DispatchQueue.main.async {
                    self.view?.updateChartWithNewValue(assetPrice: assetPrice)
                    self.view?.hideHud()
                    if self.shouldShowHowToTrade {
                        self.view?.showHowToTradeAlert()
                        self.router?.appHadFirstLaunch()
                        self.shouldShowHowToTrade = false
                    }
                 }
             }
         }
     }
    
    private func observeRange() {
           rangeObservation = observe(\.dataReceiver?.range, options: [.old, .new]) { object, change in
               if let range = change.newValue as? Range {
                   self.currentRange = range
                   if let min = range.min, let max = range.max {
                        let minValueString = self.converter.minString(from: min)
                        let maxValueString = self.converter.maxString(from: max)
                        DispatchQueue.main.async {
                            self.view?.updateMinValue(with: minValueString)
                            self.view?.updateMaxValue(with: maxValueString)
                        }
                    }
                }
            }
        }
    
    private func observeOrders() {
        ordersObservation = observe(\.dataReceiver?.orders, options: [.old, .new]) { object, change in
            if let orders = change.newValue as? [Order] {
                if let initialTime = self.view?.initialXvalue() {
                    DispatchQueue.main.async {
                        let snapshots = Converter().shapshotsFrom(orders: orders, initialTime: initialTime)
                        self.view?.update(snapshots: snapshots)
                    }
                }
            }
             WSManager.shared.register()
        }
    }
    
    private func observeNewSnapshot() {
        newSnapshotObservation = observe(\.dataReceiver?.newSnapshot, options: [.old, .new]) { object, change in
            if let snapshot = change.newValue as? Snapshot {
                DispatchQueue.main.async {
                    self.view?.updateSnapshots(with: snapshot)
                }
            }
        }
    }
    
    private func getPriceHistory() {
        if let assetId = selectedAsset?.id {
            WSManager.shared.getPriceHistory(for: assetId)
        }
    }
    
     private func getPrice() {
        stopPriceTimer()
        if WSManager.shared.dataReceiver.connectionClosed == true {
            return
        }
        guard let assetId = self.selectedAsset?.id else { return }
        WSManager.shared.getAssetPrice(for: assetId)
        self.priceTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self]  (_) in
            self?.getPrice()
        })
    }
        
    private func getAssetRange() {
         stopAsserRangeTimer()
         if WSManager.shared.dataReceiver.connectionClosed == true {
            return
         }
          DispatchQueue.main.async {
            self.assetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self]  (_) in
            guard let leverageValue = self?.selectedLeverage?.value else {return}
            let leverageParameter = leverageValue * leverageMultiplier
            guard let timeDuration = self?.selectedExpiry?.value else {return}
            let type = currentType
            guard let assedId = self?.selectedAsset?.id else {return}
            guard let stake = self?.selectedInvestment?.value else {return}
            WSManager.shared.getAssetRange(leverage: leverageParameter, timeDuration: timeDuration, type: type, assetId: assedId, stake: stake)
            })
        }
    }
    
    private func orderExecutor() {
        guard let leverageValue = selectedLeverage?.value else {return}
        let leverageParameter = leverageValue * leverageMultiplier
        guard let rangeId = currentRange?.rangeId else {return}
        guard let min = currentRange?.min else {return}
        guard let max = currentRange?.max else {return}
        WSManager.shared.orderExecutor(leverage: leverageParameter, rangeId: rangeId, min: min, max: max)
    }

    private func stopPriceTimer() {
        priceTimer?.invalidate()
        priceTimer = nil
    }
    
    private func stopAsserRangeTimer() {
        assetTimer?.invalidate()
        assetTimer = nil
    }
    func textForInfoLabel() -> String? {
        if let investment = selectedInvestment, let leverage = selectedLeverage {
            let product: Double = Double(investment.value * leverage.value)
            let text = leverage.title + " " + String(product)
            return text
        } else {
          return nil
        }
    }
    
    func update(cell: AssetCell, with text: String) {
        cell.titleLabel.text = text
    }
}




