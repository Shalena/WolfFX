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
    
    var presenter: BillingDataEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        presenter?.billingDataViewIsReady()
        localize()
    }
    
    func localize() {
        billingDataTitle.text = R.string.localizable.billingData()
        realMoneyTitle.text = R.string.localizable.realMoney()
        bonusesTitle.text = R.string.localizable.bonuses()
        dateFromTitle.text = R.string.localizable.dateFrom()
        dateToTitle.text = R.string.localizable.dateTo()
    }
    
    func updateViewWith(data: BillingData) {
        realMoneyValue.text = data.balance
        bonusesValue.text = data.bonus
        amauntPendingWithdrawValue.text = data.amauntPendingWithdrawal
        dateFromValue.text = data.dateFrom
        dateToValue.text = data.dateTo
    }
}

