//
//  SecondPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SecondPageController: UIViewController {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subtitleFirstLabel: UILabel!
    @IBOutlet weak var subtitleSecondLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var inTradeExplanation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    private func localize() {
        titleLable.text = R.string.localizable.how().uppercased()
        subtitleFirstLabel.text = R.string.localizable.makemoneY().uppercased()
        subtitleSecondLabel.text = R.string.localizable.startwithpricE().uppercased()
        mainTextLabel.text = R.string.localizable.predictThePrice()
        let inTradeExplanationString = R.string.localizable.inTradeExplaination()
        let inTradeString = R.string.localizable.inTrade().uppercased()
        let range = (inTradeExplanationString as NSString).range(of: inTradeString)
        let mutableAttributedString = NSMutableAttributedString(string: inTradeExplanationString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        inTradeExplanation.attributedText = mutableAttributedString
    }
}
