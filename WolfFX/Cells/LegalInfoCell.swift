//
//  LegalInfoCell.swift
//  WolfFX
//
//  Created by Елена Острожинская on 7/11/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class LegalInfoCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
       
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
