//
//  BillingDataViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class BillingDataViewController: UIViewController, BillingDataViewProtocol, NavigationDesign {
    @IBOutlet weak var billingDataTitle: UILabel!
    @IBOutlet weak var balanceTitle: UILabel!
    @IBOutlet weak var balanceValue: UILabel!
    @IBOutlet weak var realMoneyTitle: UILabel!
    @IBOutlet weak var bonusesTitle: UILabel!
    @IBOutlet weak var realMoneyValue: UILabel!
    @IBOutlet weak var bonusesValue: UILabel!
    @IBOutlet weak var amauntPendingWithdrawTitle: UILabel!
    @IBOutlet weak var amauntPendingWithdrawValue: UILabel!
    @IBOutlet weak var dateFromTitle: UILabel!
    @IBOutlet weak var dateFromValue: UILabel!
    @IBOutlet weak var dateToTitle: UILabel!
    @IBOutlet weak var dateToValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rangeButton: SubmitButton!
    
    var presenter: BillingDataEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        presenter?.billingDataViewIsReady()
        rangeButton.setup(backColor: .clear, borderColor: .red, text: "", textColor: .white)
        localize()
    }
    
    func localize() {
        billingDataTitle.text = R.string.localizable.billingDataTitle().localized()
        balanceTitle.text = R.string.localizable.balance().localized()
        realMoneyTitle.text = R.string.localizable.realMoney().localized()
        bonusesTitle.text = R.string.localizable.bonuses().localized()
        amauntPendingWithdrawTitle.text = R.string.localizable.amountPendingWithdrawal().localized()
        dateFromTitle.text = R.string.localizable.dateFrom().localized()
        dateToTitle.text = R.string.localizable.dateTo().localized()
    }
    
    func updateViewWith(viewModel: AccountDataViewModel) {
        DispatchQueue.main.async {
            self.balanceValue.text = viewModel.balance
            self.realMoneyValue.text = viewModel.realMoney
            self.bonusesValue.text = viewModel.bonus
            self.amauntPendingWithdrawValue.text = viewModel.amauntPendingWithdrawal
            self.dateFromValue.text = viewModel.dateFrom
            self.dateToValue.text = viewModel.dateTo
        }
    }
    
    func reloadBalanceHistory() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func makeRangeButtonDisabled() {
        rangeButton.isEnabled = false
        rangeButton.setup(backColor: .clear, borderColor: .gray)
    }
    
    @IBAction func showRangeButtonPressed(_ sender: Any) {
        presenter?.showNextRangePressed()
    }
}

extension BillingDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let items = presenter?.currentDataSource {
            return items[section][0].1.calendarDay
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceHistoryCell", for: indexPath) as? BalanceHistoryCell {
            presenter?.configure(cell: cell, at: indexPath)
            return cell
        }
        fatalError()
    }
}
