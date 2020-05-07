//
//  AssetCell.swift
//  WolfFX
//
//  Created by Елена Острожинская on 5/7/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class AssetCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .gray
    }
}
