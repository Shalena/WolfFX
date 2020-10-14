//
//  BillingDataPresenter.swift
//  WolfFX
//
//  Created by Елена Острожинская on 4/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation

class BillingDataPresenter: NSObject, BillingDataEvents {
    var view: BillingDataViewProtocol?
    var router: BillingDataTransitions?
    var websocketManager: WebsocketAccess?
    @objc dynamic var dataReceiver: DataReceiver?
    var balanceObservation: NSKeyValueObservation?
    var balanceHistoryObservation: NSKeyValueObservation?
    var balanceHistoryDataSource: [BalanceHistoryItemViewModel]?
    
    init (with view: BillingDataViewProtocol, router: BillingDataTransitions) {
        self.view = view
        self.websocketManager = WSManager.shared
        self.router = router
        dataReceiver = WSManager.shared.dataReceiver
    }

    func billingDataViewIsReady() {
        if let accountData = dataReceiver?.accountData, let viewModel = accountData.viewModel {
            view?.updateViewWith(viewModel: viewModel)
            observeBalance()
            observeBalanceHistory()
            WSManager.shared.getBalanceHistory()
        }
    }
    
    private func observeBalance() {
        balanceObservation = observe(\.dataReceiver?.accountData, options: [.old, .new]) { object, change in
            if let accountData = change.newValue as? AccountData, let viewModel = accountData.viewModel{
                self.view?.updateViewWith(viewModel: viewModel)
            }            
        }
    }
    
    private func observeBalanceHistory() {
           balanceHistoryObservation = observe(\.dataReceiver?.balanceHistoryItems, options: [.old, .new]) { object, change in
               if let array = change.newValue as? [BalanceHistoryItem] {
                    self.createDataSource(from: array)
               }
           }
       }
    
    private func createDataSource(from array: [BalanceHistoryItem]) {
       let viewModels = array.map({BalanceHistoryItemViewModel(item: $0)})
       let flatted = array.compactMap({$0.date})
       let sorted = flatted.sorted(by: { $0 > $1 })
       let convertedToDate = sorted.map{Date(timeIntervalSince1970: $0 / 1000)}
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd-MMM-yyyy"
       let convertedToString = convertedToDate.map{dateFormatter.string(from: $0)}
       let uniq = Array(Set(convertedToString))
       var conteiner = [[BalanceHistoryItemViewModel]()]
       for date in uniq {
            let filtered = viewModels.filter { $0.calendarDay == date }
            conteiner.append(filtered)
       }
        
    }
}
