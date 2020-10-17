//
//  BalanceHistoryCell.swift
//  WolfFX
//
//  Created by Елена Острожинская on 10/16/20.
//  Copyright © 2020 Елена Острожинская. All rights reserved.
//

import Foundation
import UIKit

class BalanceHistoryCell: UITableViewCell {
   @IBOutlet weak var time: UILabel!
   @IBOutlet weak var status: UILabel!
   @IBOutlet weak var inAmount: UILabel!
   @IBOutlet weak var outAmount: UILabel!
   @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
