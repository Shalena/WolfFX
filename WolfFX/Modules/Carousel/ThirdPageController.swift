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
        paragraphOneLabel.text = R.string.localizable.getPaid()
        paragraphTwoLabel.text = R.string.localizable.getPaidAgain()
        bottomDescription.text = R.string.localizable.yourWinningsAreTheSum()
    }
}
