//
//  SixthPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SixthPageController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var thirdParagraph: UILabel!
    
    @IBOutlet weak var fourthParagraph: UILabel!
    @IBOutlet weak var fifthParagraph: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.freeMoney().uppercased()
        subtitleLabel.text = R.string.localizable.ifWeSee().uppercased()
        firstParagraph.text = R.string.localizable.bonus().uppercased()
        secondParagraph.text = R.string.localizable.deposit10OrMore()
        thirdParagraph.text = R.string.localizable.getA100Bonus()
        fourthParagraph.text = R.string.localizable.upTo500()
        fifthParagraph.text = R.string.localizable.termsAndConditionsApply()
        
    }
}
