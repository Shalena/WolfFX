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
        firstParagraph.text = R.string.localizable.hitINTRADE()
        secondParagraph.text = R.string.localizable.nowTheTradeIsLive()
        thirdParagraph.text = R.string.localizable.cashIn()
        fourthParagraph.text = R.string.localizable.wellPlayed()
    }
}
