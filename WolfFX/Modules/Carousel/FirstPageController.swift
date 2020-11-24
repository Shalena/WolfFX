//
//  FirstPageController.swift
//  WolfFX
//
//  Created by Елена Острожинская on 11/23/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class FirstPageController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      localize()
    }
    
    private func localize() {
        titleLabel.text = R.string.localizable.firstPageTitle().uppercased()
        subtitleLabel.text = R.string.localizable.firstPageSubtitle().uppercased()
    }
}
