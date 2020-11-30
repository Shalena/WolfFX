//
//  BaseHeaderView.swift
//  WolfFX
//
//  Created by Елена Острожинская on 3/28/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

let initialSpeedometrValueInDegrees = 180.00

class BaseHeaderView: UIView {
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var realbalanceLabel: UILabel!
    @IBOutlet weak var realBalanceTitleLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    var previousAngle = initialSpeedometrValueInDegrees
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
        realbalanceLabel.text = WSManager.shared.dataReceiver.accountData?.realBalanceHeaderString
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
    
    func updateBonus(with string: String?) {
        bonusLabel.text = string
    }
         
    func rotateArrow(percent: Double) {
        if percent == 0.0 { return }
        let angle = 180 * percent
        if angle == previousAngle {
            return
        }
        let rotationAngle = (previousAngle - angle)
        UIView.animate(withDuration: 1) {
            self.arrowImage.transform = self.arrowImage.transform.rotated(by: CGFloat( rotationAngle * .pi/180))
        }        
        previousAngle = angle
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



