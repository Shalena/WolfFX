//
//  BillingDataViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

let footerHeight = CGFloat(100.00)
typealias TableReloadedCompletion = (() -> (Void))

import UIKit
import FSCalendar

typealias calendarCallback = ((String) -> Void)

class BillingDataViewController: UIViewController, BillingDataViewProtocol, NavigationDesign, RangeButtonDelegate {
   
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
    @IBOutlet weak var dateFromButton: UIButton!
    @IBOutlet weak var dateToButton: UIButton!
    @IBOutlet weak var dateToTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    var footerView: BalanceHistoryFooterView?
    var presenter: BillingDataEvents?
    
    var callback: calendarCallback?
    
    fileprivate let formatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM/yyyy"
           return formatter
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.isHidden = true
        calendarView.swipeToChooseGesture.isEnabled = true
        setupBaseNavigationDesign()
        footerView = BalanceHistoryFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: footerHeight), sender: self)
        presenter?.billingDataViewIsReady()
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
            self.dateFromButton.setTitle(viewModel.dateFrom, for: .normal)
            self.dateToButton.setTitle(viewModel.dateTo, for: .normal)
        }
    }
    
    @IBAction func dateFromPressed(_ sender: UIButton) {
        calendarView.isHidden = false
        showCalendar(sender)
    }
    
    @IBAction func dateToPressed(_ sender: UIButton) {
        calendarView.isHidden = false
        showCalendar(sender)
    }
    
    private func showCalendar(_ sender: UIButton) {
        callback = { string in
            sender.setTitle(string, for: .normal)
            self.calendarView.isHidden = true
        }
    }
    
    func reloadBalanceHistory(scrollIndex: Int, completion:@escaping TableReloadedCompletion, scrolling: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData {
                if scrolling {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: scrollIndex), at: .top, animated: true)
                }
                completion()
            }
        }
    }
    
    func showFooterButton() {
        tableView.tableFooterView = footerView
    }
      
    func hideFooterButton() {
        tableView.tableFooterView = nil
    }
    
    func showRangePressed() {
        presenter?.showNextRangePressed()
    }
    
    func updateFooterButton(title: String) {
        footerView?.setButton(title: title)
    }
}

extension BillingDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BalanceHistoryCell", for: indexPath) as? BalanceHistoryCell {
            presenter?.configure(cell: cell, at: indexPath)
            return cell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width - 20, height: 20))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.black
        if let items = presenter?.currentDataSource {
            label.text = items[section][0].1.calendarDay
        }
        view.addSubview(label)
        view.backgroundColor = UIColor(red: 31.0/255.0, green: 33.0/255.0, blue: 36.0/255.0, alpha: 1)
        return view
    }
}

extension BillingDataViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let string = self.formatter.string(from: date)
           callback?(string)
       }
}
