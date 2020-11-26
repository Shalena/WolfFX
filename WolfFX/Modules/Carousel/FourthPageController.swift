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
        firstParagraph.text = R.string.localizable.howMuch()
        secondParagraph.text = R.string.localizable.howMany()
        thirdParagraph.text = R.string.localizable.howFast()
        fourthParagraph.text = R.string.localizable.yourAsset()
        bottomDescription.text = R.string.localizable.yourWinningsAreTheSum()
    }
}
