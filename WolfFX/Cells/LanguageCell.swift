//
//  LanguageCell.swift
//  WolfFX
//
//  Created by Елена Острожинская on 6/6/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class LanguageCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var centralView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        centralView.layer.borderWidth = 1
        centralView.layer.borderColor = UIColor.red.cgColor

    }
}
