//
//  ThirdPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class ThirdPageController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paragraphOneLabel: UILabel!
    @IBOutlet weak var paragraphTwoLabel: UILabel!
    @IBOutlet weak var bottomDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.withRedEnvelops().uppercased()
        let getPaidString = R.string.localizable.getPaid()
        let numberOne = R.string.localizable.numerationOne()
        let range = (getPaidString as NSString).range(of: numberOne)
        let mutableAttributedString = NSMutableAttributedString(string: getPaidString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        paragraphOneLabel.attributedText = mutableAttributedString
        let getPaidAgainString = R.string.localizable.getPaidAgain()
        let numberTwo = R.string.localizable.numerationTwo()
        let range2 = (getPaidAgainString as NSString).range(of: numberTwo)
        let mutableAttributedString2 = NSMutableAttributedString(string: getPaidAgainString)
        mutableAttributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range2)
        paragraphTwoLabel.attributedText = mutableAttributedString2
        bottomDescription.text = R.string.localizable.yourWinningsAreTheSum()
    }
}
