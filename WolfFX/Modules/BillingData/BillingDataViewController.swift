//
//  BillingDataViewController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 2/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import UIKit

class BillingDataViewController: UIViewController, BillingDataViewProtocol, NavigationDesign {
    @IBOutlet weak var realMoneyValue: UILabel!
    @IBOutlet weak var bonusesValue: UILabel!
    @IBOutlet weak var amauntPendingWithdrawPendingValue: UILabel!
    @IBOutlet weak var dateFromValue: UILabel!
    @IBOutlet weak var dateToValue: UILabel!
    
    var presenter: BillingDataEvents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseNavigationDesign()
        presenter?.billingDataViewIsReady()
    }
    
    func updateViewWith(data: BillingData) {
        realMoneyValue.text = data.balance
        bonusesValue.text = data.bonus
        amauntPendingWithdrawPendingValue.text = data.amauntPendingWithdrawal
        dateFromValue.text = data.dateFrom
        dateToValue.text = data.dateTo
    }
}

