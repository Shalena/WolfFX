//
//  SeventhPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/25/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class SeventhPageController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstParagraph: UILabel!
    @IBOutlet weak var secondParagraph: UILabel!
    @IBOutlet weak var thirdParagraph: UILabel!
    @IBOutlet weak var fourthParagraph: UILabel!
    @IBOutlet weak var portrait: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        portrait.layer.cornerRadius = portrait.frame.size.height / 2
        portrait.clipsToBounds = true
        localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.aboutUs().uppercased()
        firstParagraph.text = R.string.localizable.weAreSunbeam()
        secondParagraph.text = R.string.localizable.weUseTechnology()
        thirdParagraph.text = R.string.localizable.yourFunds()
        fourthParagraph.text = R.string.localizable.sunbeamCapitalIs()
    }
}
