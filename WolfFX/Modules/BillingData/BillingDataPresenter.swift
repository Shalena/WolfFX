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
    var globalDataSource = [[[(Date, BalanceHistoryItemViewModel)]]]() // months
    var currentDataSource = [[(Date, BalanceHistoryItemViewModel)]]()  // days
    var monthsAmount = 1
    
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
            view?.showHud()
            WSManager.shared.getBalanceHistory()
        }
    }
    
    func numberOfSections() -> Int {
        return currentDataSource.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return currentDataSource[section].count
    }
    
    func configure(cell: BalanceHistoryCell, at index: IndexPath) {
        let array = currentDataSource[index.section]
        let viewModel = array[index.row].1
        cell.time.text = viewModel.hoursMinutes
        cell.status.text = viewModel.descriptionString
        if viewModel.transactionStatus == .win {
            cell.inAmount.text = viewModel.amount
        } else if viewModel.transactionStatus == .loose {
            cell.outAmount.text = viewModel.amount
        }
            cell.balance.text = viewModel.balance
    }
    
    func showNextRangePressed() {
        view?.showHud()
        let lastIndex = currentDataSource.count 
        currentDataSource = currentDataSource + globalDataSource[monthsAmount]
        monthsAmount+=1        
        if monthsAmount <= globalDataSource.count {
            view?.reloadBalanceHistory(scrollIndex: lastIndex, completion: {
                self.view?.hideHud()
            })
        }
        if monthsAmount == globalDataSource.count {
            view?.makeRangeButtonDisabled()
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
       let safeArray = array.filter {$0.date != nil}
       let sorted = safeArray.sorted(by: { $0.date! > $1.date! })
       var combined = [(Date, BalanceHistoryItemViewModel)]()
       for item in sorted {
            let date = Date(timeIntervalSince1970: item.date! / 1000)
            let viewModel = BalanceHistoryItemViewModel(item: item)
            let combinedItem = (date, viewModel)
            combined.append(combinedItem)
       }
        let calendar = Calendar.current
        let years = combined.map{calendar.component(.year, from: $0.0)}
        let uniqueYears = years.unique
        var sortedByYear = [[(Date, BalanceHistoryItemViewModel)]]()
        for year in uniqueYears {
            let filteredByYear = combined.filter{calendar.component(.year, from: $0.0) == year}
            sortedByYear.append(filteredByYear)
        }
        var commonArray = [[[(Date, BalanceHistoryItemViewModel)]]]()
        for array in sortedByYear {
            var sortedByMonth = [[(Date, BalanceHistoryItemViewModel)]]()
            let months = array.map{calendar.component(.month, from: $0.0)}
            let uniqueMonths = months.unique
            for month in uniqueMonths {
               let filteredByMonth = array.filter{calendar.component(.month, from: $0.0) == month}
               sortedByMonth.append(filteredByMonth)
            }
            commonArray.append(sortedByMonth)
        }
        let monthForAllYears = commonArray.reduce([], +)
        var accum = [[[(Date, BalanceHistoryItemViewModel)]]]()
        for month in monthForAllYears {
            var monthAccum = [[(Date, BalanceHistoryItemViewModel)]]()
            let days = month.map{calendar.component(.day, from: $0.0)}
            let uniqueDays = days.unique
            for day in uniqueDays {
                let filteredByDay = month.filter{calendar.component(.day, from: $0.0) == day}
                monthAccum.append(filteredByDay)
            }
            accum.append(monthAccum)
        }
        globalDataSource = accum
        currentDataSource = globalDataSource[0]
        view?.reloadBalanceHistory(scrollIndex: 0, completion: {
            self.view?.hideHud()
        })
    }
}
