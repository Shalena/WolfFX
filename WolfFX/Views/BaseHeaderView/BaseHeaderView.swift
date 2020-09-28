//
//  BaseHeaderView.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class BaseHeaderView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var realbalanceLabel: UILabel!
    @IBOutlet weak var realBalanceTitleLabel: UILabel!
    
    let presenter = BaseHeaderViewPresenter()
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    func commonInit() {
        Bundle.main.loadNibNamed("BaseHeaderView", owner: self, options: nil)
        contentView.fixInView(self)
        presenter.view = self
        presenter.observe()
        realbalanceLabel.text = WSManager.shared.dataReceiver.realBalanceString
        setupGestes()
        localize()
    }
    
    func localize() {
        realBalanceTitleLabel.text = R.string.localizable.realBalance().localized()
    }
    
    
    func updateWith(realBalance: String) {
        DispatchQueue.main.async {
            self.realbalanceLabel.text = realBalance
        }       
    }
    
    private func setupGestes() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func viewTapped(_ sender: UITapGestureRecognizer? = nil) {
        if let tabBar: UITabBarController = self.window?.rootViewController as? UITabBarController {
            tabBar.selectedIndex = 1
        }
    }
}



