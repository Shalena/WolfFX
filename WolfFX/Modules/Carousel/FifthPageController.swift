//
//  FifthPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class FifthPageController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var thirdParagraph: UILabel!
    @IBOutlet weak var fourthParagraph: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.howToDoIt().uppercased()
        
        let hitInTradeString = R.string.localizable.hitINTRADE()
        let inTrade = R.string.localizable.inTrade().uppercased()
        let rangeInTrade = (hitInTradeString as NSString).range(of: inTrade)
        let mutableAttributedStringHit = NSMutableAttributedString(string: hitInTradeString)
        mutableAttributedStringHit.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: rangeInTrade)
        firstParagraph.attributedText = mutableAttributedStringHit
        
        secondParagraph.text = R.string.localizable.nowTheTradeIsLive()
        thirdParagraph.text = R.string.localizable.cashIn()
        
        let wellPlayedGoodLuckString = R.string.localizable.wellPlayedGoodLuck()
        let wellPlayed = R.string.localizable.wellPlayed().uppercased()
        let rangeWellPlayed = (wellPlayedGoodLuckString as NSString).range(of: wellPlayed)
        let mutableAttributedStringWell = NSMutableAttributedString(string: wellPlayedGoodLuckString)
        mutableAttributedStringWell.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: rangeWellPlayed)
        fourthParagraph.attributedText = mutableAttributedStringWell
    }
}
