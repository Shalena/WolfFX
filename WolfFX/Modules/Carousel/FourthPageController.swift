//
//  FourthPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/24/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class FourthPageController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var thirdParagraph: UILabel!
    @IBOutlet weak var fourthParagraph: UILabel!
    @IBOutlet weak var bottomDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.control().uppercased()
        subtitleLabel.text = R.string.localizable.choose().uppercased()
        
        let howMuchString = R.string.localizable.howMuch()
        let numberOne = R.string.localizable.numerationOne()
        let range1 = (howMuchString as NSString).range(of: numberOne)
        let mutableAttributedString1 = NSMutableAttributedString(string: howMuchString)
        mutableAttributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
        firstParagraph.attributedText = mutableAttributedString1
       
        let howManyString = R.string.localizable.howMany()
        let numberTwo = R.string.localizable.numerationTwo()
        let range2 = (howManyString as NSString).range(of: numberTwo)
        let mutableAttributedString2 = NSMutableAttributedString(string: howManyString)
        mutableAttributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range2)
        secondParagraph.attributedText = mutableAttributedString2
        
        let howFastString = R.string.localizable.howFast()
        let numberThree = R.string.localizable.numerationThree()
        let range3 = (howFastString as NSString).range(of: numberThree)
        let mutableAttributedString3 = NSMutableAttributedString(string: howFastString)
        mutableAttributedString3.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range3)
        thirdParagraph.attributedText = mutableAttributedString3
        
        let yourAssetString = R.string.localizable.yourAsset()
        let numberFour = R.string.localizable.numerationFour()
        let range4 = (yourAssetString as NSString).range(of: numberFour)
        let mutableAttributedString4 = NSMutableAttributedString(string: yourAssetString)
        mutableAttributedString4.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range4)
        fourthParagraph.attributedText = mutableAttributedString4
       
        bottomDescription.text = R.string.localizable.yourWinningsAreTheSum()
    }
}
